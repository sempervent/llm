#!/usr/bin/env bash
#/ This is a setup script to install the simplest way to interact with a 
#/ LLM. We use a script to download the files locally in a ./models folder
#/ via the `docker-compose.yaml' provided by the developers of
#/      Dalai: https://github.com/cocktailpeanut/dalai
#/ and modified by myself and
#/ this
#/ list
#/ of other
#>Prepare Dalai for installation of models and removal of non-quantized models.
#> Usage:
#>   setup.sh [OPTIONS]
#>      -h|--help show this help and exit
#>      -a|--alpaca available models to install: 7B 13B
#>      -l|--llama available models to install: 7B 13B 30B 65B
## Helper functions
dco() {
    if docker compose version > /dev/null 2>&1; then
        docker compose "$@"
    else
        docker-compose "$@"
    fi
}
remove_non_quantized() {
    dco run dalai bash -c 'find /root/dalai/models -type f ! -name "*.pth" -delete'
}
show_help() {
    grep '^#>' "$0" | sed 's/^#> //'
}
## Read in Arguments
while (( "$#" )); do
    case $1 in
        -a|--alpaca)
            shift
            while [[ "$1" != -* && "$#" -gt 0 ]]; do
                ALPACA +=("$1")
                shift
            done
            ;;
        -l|--llama)
            shift
            while [[ "$1" != -* && "$#" - gt 0 ]]; do
                LLAMA+=("$1")
                shift
            done
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown paramater passed: $1"
            exit 1
            ;;
    esac
done
dco build
if [[ -n $ALPACA ]]; then
    for i in "${ALPACA[@]}"; do
        dco run dalai npx dalai alpaca install "$i"
    done
fi
if [[ -n $LLAMA ]]; then
    for i in "${LLAMA[@]}"; do
        dco run dalai npx dalai llama install "$i"
        remove_non_quantized
    done
fi
dco up -d
# Print the URL
echo "URL is available: http://127.0.0.1:5353"
