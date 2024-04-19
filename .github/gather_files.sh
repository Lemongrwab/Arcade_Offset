#!/usr/bin/env bash
# Copyright (c) 2021-2022 José Manuel Barroso Galindo <theypsilon@gmail.com>

set -euo pipefail

update_distribution() {
    local TMP_FOLDER="${1}"
    local REGISTRY="$(pwd)/${2}"


    local REPOSITORY_URL="${REPOSITORY_URL:-'https://github.com/Toryalai1/Arcade_Offset'}"

    echo "download_repository"
    rm -rf "${TMP_FOLDER}" || true
    mkdir -p "${TMP_FOLDER}"
    download_repository "${TMP_FOLDER}" "${REPOSITORY_URL}.git" "main"

    rm "${REGISTRY}" || true

    local IFS=$'\n'

    pushd "${TMP_FOLDER}/release"

    for mra in $(find "_Arcade Offset" -type f -iname '*.mra') ; do
        echo "_Arcade/${mra}:release/${mra}" >> "${REGISTRY}"
    done

    popd

    cat "${REGISTRY}"
}

download_repository() {
    local FOLDER="${1}"
    local GIT_URL="${2}"
    local BRANCH="${3}"
    pushd "${TMP_FOLDER}" > /dev/null 2>&1
    git init -q
    git remote add origin "${GIT_URL}"
    git -c protocol.version=2 fetch --depth=1 -q --no-tags --prune --no-recurse-submodules origin "${BRANCH}"
    git checkout -qf FETCH_HEAD
    popd > /dev/null 2>&1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    update_distribution "${1}" "${2}"
fi
