#!/bin/sh

set -e

if [[ $# -ne 1 ]] ; then
    echo "Please specify the theme vendor as the first and only argument!" >&2
    exit 5
fi

function crit() {
    echo "$1" >&2
    exit "${2:-1}"
}

STATIC_DIR="./pub/static/frontend"

THEME_VENDOR="$1"
THEME_DIR="${STATIC_DIR}/${THEME_VENDOR}"

BUILD_FILE="./build.js"
MAGEPACK="magepack"

echo "[INFO] Using theme vendor '$THEME_VENDOR'"

which "$MAGEPACK" || crit "[CRITICAL] No magepack binary '$MAGEPACK' found" 10

[[ ! -f "$BUILD_FILE" ]]    && crit "[CRITICAL] No '$BUILD_FILE' file found in current directory" 20
[[ ! -d "$STATIC_DIR" ]]    && crit "[CRITICAL] No base magento frontend assets dir '$STATIC_DIR' found - did you already build the themes?" 21
[[ ! -d "$THEME_DIR" ]]     && crit "[CRITICAL] No vendor frontend assets dir '$THEME_DIR' found - did you already build the themes?" 22

function pack_theme_lang() {
    THEME="$1"
    LANG="$2"

    TARGET_DIR="$THEME_DIR/$THEME/$LANG"

    echo -e "\n[INFO] Packing theme '$THEME' language '$LANG' in '$TARGET_DIR'..."

    magepack --bundle --config "$BUILD_FILE" --dir "$TARGET_DIR"
}

function list_themes() {
    (cd "$THEME_DIR"; ls -1da *)
}

function list_theme_langs() {
    THEME_NAME="$1"

    (cd "${THEME_DIR}/${THEME_NAME}"; ls -1da *)
}

list_themes | while read THEME_NAME ; do
    echo " * Theme '$THEME_NAME'"

    list_theme_langs "$THEME_NAME" | while read THEME_LANG ; do
        echo -e "   - Language '$THEME_LANG'"
        pack_theme_lang "$THEME_NAME" "$THEME_LANG"
    done
done

echo "All themes have been processed successfully"