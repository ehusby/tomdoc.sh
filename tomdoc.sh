#!/bin/sh
# Parse TomDoc'd shell scripts and generate pretty documentation from it
#
# Written by Mathias Lafeldt <mathias.lafeldt@gmail.com>

file="$1"

generate() {
    cat <<EOF
--------------------------------------------------------------------------------
$1

$2
EOF
}

parse() {
    doc=
    while read -r line; do
        case "$line" in
        '#'|'# '*)
            line="${line#\#}"
            line="${line# }"
            doc="$doc$line
"
            ;;
        [!#]*)
            test -n "$doc" && {
                # XXX only support functions for now
                func="$(expr "$line" : '\([a-zA-Z_]*\)[ \t]*()')" &&
                generate "$func()" "$doc"
                doc=
            }
            ;;
       esac
    done
}

cat "$file" | parse
