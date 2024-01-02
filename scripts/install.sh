#!/bin/bash
set -e

scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="${scripts_dir}/.."

source "${scripts_dir}/variables.sh"

cd "${root_dir}"

# Create .env files
./scripts/install_env.sh $@

echo "${tput_green}Done!${tput_reset}"
