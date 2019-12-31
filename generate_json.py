#!/usr/bin/env python
import json
import logging
import os
import sys

logging.basicConfig(
    format="[%(asctime)s] [%(process)d] [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S %z",
    level=logging.INFO
)

TESTS_DIR="tests"
LANG_PROPERTIES_FILE="lang.properties"
SKIP_LANG_FILE=".skip"

def parse_lang_properties(lang_properties):
    variables = {"ARGS": "%s"}
    for line in lang_properties.split("\n"):
        key, value = line.split("=", maxsplit=1)
        variables[key] = value[1:-1]

    versions = variables["VERSIONS"].split()
    languages = []

    for version in versions:
        language = {}
        variables["VERSION"] = version
        for key in variables:
            resolved_value = variables[key]
            for key2 in variables:
                resolved_value = resolved_value.replace(f"${key2}", variables[key2])
            language[key] = resolved_value
        languages.append(language)
    return languages

if __name__ == "__main__":
    if not os.path.exists(TESTS_DIR):
        logging.error("Tests directory does not exist. Please run this script from the root of the project.")
        sys.exit(-1)

    languages = []
    for directory in os.listdir(TESTS_DIR):
        if not os.path.isdir(os.path.join(TESTS_DIR, directory)):
            continue
        if os.path.exists(os.path.join(TESTS_DIR, directory, SKIP_LANG_FILE)):
            continue
        with open(os.path.join(TESTS_DIR, directory, LANG_PROPERTIES_FILE)) as f:
            lang_properties = f.read()
        languages.extend(parse_lang_properties(lang_properties))

    languages.sort(key=lambda x: x["NAME"].lower())

    cleaned_languages = []
    for id, language in enumerate(languages, start=1):
        cleaned_language = {
            "id": id,
            "name": language["NAME"],
            "is_archived": False,
            "source_file": language["SOURCE_FILE"]
        }

        if language["COMPILE_CMD"] != "":
            compile_cmd = language["COMPILE_CMD"]
            if "COMPILE_CMD_ISOLATE" in language:
                compile_cmd = language["COMPILE_CMD_ISOLATE"]
            cleaned_language["compile_cmd"] = compile_cmd

        run_cmd = language["RUN_CMD"]
        if "RUN_CMD_ISOLATE" in language:
            run_cmd = language["RUN_CMD_ISOLATE"]
        cleaned_language["run_cmd"] = run_cmd

        cleaned_languages.append(cleaned_language)

    print(json.dumps(cleaned_languages, indent=4))