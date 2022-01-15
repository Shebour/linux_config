#!/bin/bash
#shellcheck disable=SC3012
#shellcheck disable=SC3015
#shellcheck disable=SC2086
#shellcheck disable=SC3010
#shellcheck disable=SC2039
#shellcheck disable=SC2001

get_tag ()
{
    git tag -l 2> /dev/null | grep "exercises-${PWD##*/}-v*"
}

list_tag=$(get_tag "$1")
max=0
for tags in $list_tag;do
    if [ "$max" \< "$tags" ]; then
        max="$tags"
    fi
done

re='^[0-9]+$'

if ! [[ "$max" =~ $re ]]; then
    nb=$(echo "$max" | sed -e "s/^exercises-${PWD##*/}-v//")
    nb2=$(echo "${nb} + 0.1" | bc)
    echo "exercises-${PWD##*/}-v${nb2}"
else
    echo "exercises-${PWD##*/}-v1.0"
fi
