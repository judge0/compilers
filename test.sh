#!/bin/bash
set -e

if [[ ! -f /.dockerenv ]]; then
    echo "Creating a new container from image $1"
    docker run -it --privileged --rm -v $PWD:/api-base -w /api-base $1 bash
    exit 0
fi

function get_argument() {
    if [[ -n "$2" ]] && [[ ${2:0:1} != "-" ]]; then
        echo "$2"
    else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
    fi
}

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

edition="standard"
isolate=0
cleanup=1
while [[ $# -gt 0 ]]; do
    case "$1" in
        --edition)
            edition="$(get_argument $1 $2)"
            shift 2
            ;;
        --isolate)
            isolate=1
            shift
            ;;
        --compiler)
            compiler="$(get_argument $1 $2)"
            shift 2
            ;;
        --skip-cleanup)
            cleanup=0
            shift
            ;;
        *)
            echo "Error: Unknown option $1" >&2
            echo "Usage: $0 [--edition edition] [--isolate] [--compiler compiler] [--skip-cleanup]"
            exit 1
            ;;
    esac
done

readonly LANG_PROPERTIES_FILE=lang.properties
readonly SKIP_FILE=.skip
readonly SQLITE_DB=db.sqlite

pushd compilers/$edition
for dir in *; do
    [[ ! -d $dir ]] && continue
    [[ ! -z "$compiler" && "$dir" != "$compiler" ]] && continue
    [[ -z "$compiler" && -f $dir/$SKIP_FILE ]] && continue

    test_dir=$dir/test
    [[ ! -d $test_dir ]] && continue

    pushd $test_dir
    for lang in *; do
        [[ ! -d $lang ]] && continue

        lang_properties=$lang/$LANG_PROPERTIES_FILE
        [[ ! -f $lang_properties ]] && continue

        source $lang_properties

        pushd $lang
        for VERSION in $VERSIONS; do
            source $LANG_PROPERTIES_FILE
            echo "+-------------------------------------------------------------------------------"
            echo "| $NAME "
            echo "+-------------------------------------------------------------------------------"

            if [[ $isolate -eq 1 ]]; then
                echo "Initializing isolate box."

                set +e
                workdir="$(isolate --cg --init)"
                isolate_exit=$?
                set -e
                if [[ ! $isolate_exit -eq 0 ]]; then
                    echo "Sandbox not cleaned. Cleaning now."
                    isolate --cg --cleanup
                    workdir="$(isolate --cg --init)"
                fi

                boxdir=$workdir/box
                echo "Using box directory $boxdir"

                cp $SOURCE_FILE $boxdir
                [[ -f $SQLITE_DB ]] && cp $SQLITE_DB $boxdir

                if [[ ! -z "$COMPILE_CMD" ]]; then
                    if [[ ! -z "$COMPILE_CMD_ISOLATE" ]]; then
                        COMPILE_CMD=$COMPILE_CMD_ISOLATE
                        unset COMPILE_CMD_ISOLATE
                    fi

                    echo $COMPILE_CMD > $boxdir/compile

                    echo "Compiling inside isolate."
                    set +e
                    isolate --cg -i /dev/null -t 15 -x 0 -w 20 -k 128000 -p120 --cg-timing --cg-mem=512000 -f 4096 \
                            -E HOME=/tmp -E PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"  \
                            -E LANG -E LANGUAGE -E LC_ALL -d /etc:noexec --run -- /bin/bash compile

                    if [[ $? != 0 ]]; then
                        if [[ $cleanup -eq 1 ]]; then
                            echo "Running isolate cleanup."
                            isolate --cg --cleanup
                            rm -rf $workdir || true
                        else
                            echo "Skipping cleanup after execution."
                        fi
                        exit -1
                    fi
                    set -e
                fi

                if [[ ! -z "$RUN_CMD_ISOLATE" ]]; then
                    RUN_CMD=$RUN_CMD_ISOLATE
                    unset RUN_CMD_ISOLATE
                fi

                echo $RUN_CMD > $boxdir/run
                echo "world" > $workdir/stdin

                echo "Running inside isolate."

                set +e
                isolate --cg -t 5 -x 0.5 -w 5 -k 64000 -p60 --cg-timing --cg-mem=128000 -f 1024 \
                        -E HOME=/tmp -E PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"  \
                        -E LANG -E LANGUAGE -E LC_ALL -d /etc:noexec --run -- /bin/bash run < $workdir/stdin

                if [[ ! $? -eq 0 ]]; then
                    exit_after_cleanup=true
                fi

                if [[ $cleanup == 1 ]]; then
                    echo "Running isolate cleanup."
                    isolate --cg --cleanup
                    rm -rf $workdir || true
                else
                    echo "Skipping cleanup after execution."
                fi

                [[ $exit_after_cleanup == true ]] && exit -1

                set -e
            else
                bash -c "$COMPILE_CMD"
                echo "world" | bash -c "$RUN_CMD"
                rm $(ls . | grep -v \.${SOURCE_FILE##*.} | grep -v $LANG_PROPERTIES_FILE | grep -v $SQLITE_DB) &> /dev/null || true
            fi

            echo
        done
        popd
    done
    popd
done
popd