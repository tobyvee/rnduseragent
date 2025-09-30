#!/bin/bash

set -euo pipefail

VERSION="1.0.0"
FILENAME=""
INSTALL=false

function usage {
  echo "Usage: $0"
  echo "  -h, --help: Display this help message"
  echo "  -v, --version: Display the version"
  echo "  -i, --install: Install rnduseragent to /usr/local/bin"
  echo ""
  echo "Requirements: jq, curl"
}

function version {
  echo "$VERSION"
  exit 0
}

function help {
  usage
  exit 0
}

function getopts {
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
    -h | --help)
      help
      ;;
    -v | --version)
      version
      ;;
    -i | --install)
      INSTALL=true
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    esac
    shift
  done
}

function timestamp {
  date +%s
}

function red {
  local RED='\033[91m'
  local RESET='\033[0m'
  echo -e "${RED}$1${RESET}"
}

function fatal {
  red FATAL: "$1"
  exit 1
}

function check_requirements {
  if ! command -v jq &>/dev/null; then
    fatal "jq is required"
  fi
  if ! command -v curl &>/dev/null; then
    fatal "curl is required"
  fi
  if ! command -v awk &>/dev/null; then
    fatal "awk is required"
  fi
}

function set_filename {
  FILENAME="$(timestamp)-rnduseragent"
}

function download {
  curl -sSL https://cdn.jsdelivr.net/gh/microlinkhq/top-user-agents@master/src/index.json >"/tmp/$FILENAME.json"
}

function parse {
  jq -r '.[]' "/tmp/$FILENAME.json" >"/tmp/$FILENAME.txt"
}

function copy_template {
  cp -a ./useragent.template "../dist/$FILENAME.sh"
}

function prefix {
  sed -i -e "s/^/\"/" /tmp/"$FILENAME".txt
}

function suffix {
  sed -i -e "s/$/\"/" /tmp/"$FILENAME".txt
}

function replace {
  prefix
  suffix
  awk '/%%USER_AGENTS%%/{system("cat /tmp/'"$FILENAME"'.txt");next}1' '../dist/'"$FILENAME"'.sh' >"../dist/$FILENAME.tmp" && mv "../dist/$FILENAME.tmp" "../dist/$FILENAME.sh"
}

function remove_symlink {
  if [ -L "../dist/latest" ]; then
    rm -f "../dist/latest"
  fi
}

function symlink {
  remove_symlink
  ln -s "../dist/$FILENAME.sh" "../dist/latest"
}

function make_executable {
  chmod +x "../dist/$FILENAME.sh"
}

function install {
  if [ -L "/usr/local/bin/rnduseragent" ]; then
    rm -f "/usr/local/bin/rnduseragent"
  fi
  ln -s "../dist/latest" "/usr/local/bin/rnduseragent"
}

function rnduseragent {
  getopts "$@"
  check_requirements
  set_filename
  download
  parse
  copy_template
  replace
  make_executable
  symlink
  if [ "$INSTALL" = true ]; then
    install
  fi
}

rnduseragent "$@"
