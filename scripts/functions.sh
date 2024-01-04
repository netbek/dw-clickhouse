#!/bin/bash

function render_template() {
    local pretty=0
    local prettier_parser=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --pretty)
                pretty=1
                shift
                ;;
            --prettier_parser)
                if [ -n "$2" ]; then
                    prettier_parser="$2"
                    shift
                else
                    echo "Error: --prettier_parser option requires a valid parser argument."
                    exit 1
                fi
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    if [ "$#" -lt 2 ]; then
        echo "Error: Incorrect number of arguments. Please provide 'templates_dir' and 'template'."
        exit 1
    fi

    local templates_dir="$1"
    local template="$2"
    local context=()
    shift 2

    while [[ $# -gt 0 ]]; do
        context+=("$1")
        shift
    done

    docker run --rm \
        -v ${templates_dir}:/templates \
        -e TEMPLATE=${template} \
        -e PRETTY=${pretty} \
        -e PRETTIER_PARSER=${prettier_parser} \
        ghcr.io/netbek/jinja2-docker:v0.0.5 \
        "${context[@]}"
}

function yq_cmd() {
    docker run --rm -i -v "${PWD}":/workdir mikefarah/yq:4.40.4 "$@"
}
