#!/bin/bash
nimDir=/usr/local/nim
nim=$nimDir/bin/nim

stable_version=`curl -fSsL https://nim-lang.org/channels/stable`
[[ -f $nim ]] && current_version=`$nim -v | head -n 1 | awk '{ print $4 }'`

echo "Current version: $current_version"
echo "Latest stable version: $stable_version"

if [[ $stable_version != $current_version ]]; then
    echo "Updating Nim to latest stable version."
    curl -fSsL "https://nim-lang.org/download/nim-$stable_version-linux_x64.tar.xz" -o /tmp/nim.tar.xf
    rm -rf $nimDir
    mkdir $nimDir
    tar -xf /tmp/nim.tar.xf -C $nimDir --strip-components=1
    chmod +x $nim
    rm /tmp/nim.tar.xf
else
    echo "Nim is already up to date."
fi