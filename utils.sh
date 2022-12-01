#!/bin/sh

set -e

die() {
    printf "\033[0;31m${@}\033[0m\n"
    return 1
}

clang-format-c()
{
    clang_format_file="${PWD}/.clang-format"
    if ! test -f "${clang_format_file}"; then
        die "Failed to find clang-format configuration at ${clang_format_file}"
    fi

    find "${PWD}" -type f -name '*.c' -exec /bin/clang-format --style=file -i {} ';'
    find "${PWD}" -type f -name '*.h' -exec /bin/clang-format --style=file -i {} ';'
}

clang-format-cpp()
{
    clang_format_file="${PWD}/.clang-format"
    if ! test -f "${clang_format_file}"; then
        die "Failed to find clang-format configuration at ${clang_format_file}"
    fi

    find "${PWD}" -type f -name '*.cc' -exec /bin/clang-format --style=file -i {} ';'
    find "${PWD}" -type f -name '*.hh' -exec /bin/clang-format --style=file -i {} ';'
    find "${PWD}" -type f -name '*.hxx' -exec /bin/clang-format --style=file -i {} ';'
}

gitpush()
{

    repo="$(/bin/git rev-parse --show-toplevel 2>/dev/null)"
    if test "$?" -ne 0; then
        die "You must run this script from the work tree of a git repository"
    fi
    if [ $# -ne 1 ]; then
        echo "Usage: gitpush <commit_msg>"
        return 1
    fi
    git commit -m "$1"
    git push
}

gitpushtag()
{
    repo="$(/bin/git rev-parse --show-toplevel 2>/dev/null)"
    if test "$?" -ne 0; then
        die "You must run this script from the work tree of a git repository"
    fi

    if [ $# -ne 2 ]; then
        echo "Usage: gitpushtag <commit_msg> <tag>"
        return 1
    fi
    echo "Tag: $2"
    read -r -p "Are you sure? [Y/n] " response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        git commit -m "$1"
        git tag -a "$2" -m "$1"
        git push --follow-tags
    fi
}
