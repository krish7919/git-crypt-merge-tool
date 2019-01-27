#!/usr/bin/env bash

#
# git-crypt-merge: helper script for merging changes in git-crypt encrypted
# files.
#

set -e
set -o nounset

PROGNAME=$(basename $0)

usage() {
    cat <<EOF
usage: ${PROGNAME} -b BASE -c CURRENT -o OTHER -k KEY_NAME -l LOCATION
  -h, --help Display this help
EOF
}

if [[ $# -lt 10 ]]; then
    echo "${PROGNAME}: not enough arguments" >&2
    usage >&2
    exit 1
fi

BASE=""
CURRENT=""
OTHER=""
KEY_NAME=""
LOCATION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            usage
            exit 0
            ;;
        --base|-b)
            BASE="$2"
            shift
            shift
            ;;
        --current|-c)
            CURRENT="$2"
            shift
            shift
            ;;
        --other|-o)
            OTHER="$2"
            shift
            shift
            ;;
        --key_name|-k)
            KEY_NAME="$2"
            shift
            shift
            ;;
        --location|-l)
            LOCATION="$2"
            shift
            shift
            ;;
        *)
            echo "${PROGNAME}: unknown option $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

# Temporary file names to store decrypted files
base_decrypted="$(mktemp)"
current_decrypted="$(mktemp)"
other_decrypted="$(mktemp)"
trap "{ rm -f $base_decrypted; }" EXIT
trap "{ rm -f $current_decrypted; }" EXIT
trap "{ rm -f $other_decrypted; }" EXIT

echo "Starting with git-crypt-merge at ${LOCATION}...."

echo "DEBUG: Decrypting base...."
cat ${BASE} | git-crypt smudge --key-name=${KEY_NAME} > "${base_decrypted}"

echo "DEBUG: Decrypting current...."
cat ${CURRENT} | git-crypt smudge --key-name=${KEY_NAME} > "${current_decrypted}"

echo "DEBUG: Decrypting other...."
cat ${OTHER} | git-crypt smudge --key-name=${KEY_NAME} > "${other_decrypted}"

echo "Trying auto-merge...."

if ! git merge-file -L CURRENT -L BASE -L OTHER ${current_decrypted} ${base_decrypted} ${other_decrypted}; then
    echo "Merge conflict; opening editor to resolve." >&2
    ${EDITOR:-vi} ${current_decrypted}
fi

# Re-encrypt the file
cat "${current_decrypted}" | git-crypt clean --key-name=${KEY_NAME} > $CURRENT

