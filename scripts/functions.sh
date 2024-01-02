#!/bin/bash

function render_template() {
    local template_file="$1"
    local output_file="$2"
    local variables=("$@")

    local is_dry_run=false
    if [ "${variables[-1]}" == "--dry-run" ]; then
        is_dry_run=true
        unset variables[-1]
    fi

    local template=$(<"$template_file")
    local i=0

    for ((i = 3; i < ${#variables[@]}; i+=2)); do
        local variable="${variables[i-1]}"
        local value="${variables[i]}"
        template="${template//\{\{ $variable \}\}/$value}"
    done

    if [ "$is_dry_run" == true ]; then
        echo "Dry run:"
        echo "$template"
    else
        echo "$template" > "$output_file"
    fi
}
