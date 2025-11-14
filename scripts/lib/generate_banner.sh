#!/bin/bash

# ASCII Banner Generator
# Generates stylized ASCII art banners using ANSI Shadow font
# Used during setup to create custom banners for project names

# Character definitions - ANSI Shadow font (6 lines per character)
declare -A GLYPHS

# Initialize all glyphs
init_glyphs() {
    GLYPHS[A,0]=' █████╗ '
    GLYPHS[A,1]='██╔══██╗'
    GLYPHS[A,2]='███████║'
    GLYPHS[A,3]='██╔══██║'
    GLYPHS[A,4]='██║  ██║'
    GLYPHS[A,5]='╚═╝  ╚═╝'

    GLYPHS[B,0]='██████╗ '
    GLYPHS[B,1]='██╔══██╗'
    GLYPHS[B,2]='██████╔╝'
    GLYPHS[B,3]='██╔══██╗'
    GLYPHS[B,4]='██████╔╝'
    GLYPHS[B,5]='╚═════╝ '

    GLYPHS[C,0]=' ██████╗'
    GLYPHS[C,1]='██╔════╝'
    GLYPHS[C,2]='██║     '
    GLYPHS[C,3]='██║     '
    GLYPHS[C,4]='╚██████╗'
    GLYPHS[C,5]=' ╚═════╝'

    GLYPHS[D,0]='██████╗ '
    GLYPHS[D,1]='██╔══██╗'
    GLYPHS[D,2]='██║  ██║'
    GLYPHS[D,3]='██║  ██║'
    GLYPHS[D,4]='██████╔╝'
    GLYPHS[D,5]='╚═════╝ '

    GLYPHS[E,0]='███████╗'
    GLYPHS[E,1]='██╔════╝'
    GLYPHS[E,2]='█████╗  '
    GLYPHS[E,3]='██╔══╝  '
    GLYPHS[E,4]='███████╗'
    GLYPHS[E,5]='╚══════╝'

    GLYPHS[F,0]='███████╗'
    GLYPHS[F,1]='██╔════╝'
    GLYPHS[F,2]='█████╗  '
    GLYPHS[F,3]='██╔══╝  '
    GLYPHS[F,4]='██║     '
    GLYPHS[F,5]='╚═╝     '

    GLYPHS[G,0]=' ██████╗ '
    GLYPHS[G,1]='██╔════╝ '
    GLYPHS[G,2]='██║  ███╗'
    GLYPHS[G,3]='██║   ██║'
    GLYPHS[G,4]='╚██████╔╝'
    GLYPHS[G,5]=' ╚═════╝ '

    GLYPHS[H,0]='██╗  ██╗'
    GLYPHS[H,1]='██║  ██║'
    GLYPHS[H,2]='███████║'
    GLYPHS[H,3]='██╔══██║'
    GLYPHS[H,4]='██║  ██║'
    GLYPHS[H,5]='╚═╝  ╚═╝'

    GLYPHS[I,0]='██╗'
    GLYPHS[I,1]='██║'
    GLYPHS[I,2]='██║'
    GLYPHS[I,3]='██║'
    GLYPHS[I,4]='██║'
    GLYPHS[I,5]='╚═╝'

    GLYPHS[J,0]='     ██╗'
    GLYPHS[J,1]='     ██║'
    GLYPHS[J,2]='     ██║'
    GLYPHS[J,3]='██   ██║'
    GLYPHS[J,4]='╚█████╔╝'
    GLYPHS[J,5]=' ╚════╝ '

    GLYPHS[K,0]='██╗  ██╗'
    GLYPHS[K,1]='██║ ██╔╝'
    GLYPHS[K,2]='█████╔╝ '
    GLYPHS[K,3]='██╔═██╗ '
    GLYPHS[K,4]='██║  ██╗'
    GLYPHS[K,5]='╚═╝  ╚═╝'

    GLYPHS[L,0]='██╗     '
    GLYPHS[L,1]='██║     '
    GLYPHS[L,2]='██║     '
    GLYPHS[L,3]='██║     '
    GLYPHS[L,4]='███████╗'
    GLYPHS[L,5]='╚══════╝'

    GLYPHS[M,0]='███╗   ███╗'
    GLYPHS[M,1]='████╗ ████║'
    GLYPHS[M,2]='██╔████╔██║'
    GLYPHS[M,3]='██║╚██╔╝██║'
    GLYPHS[M,4]='██║ ╚═╝ ██║'
    GLYPHS[M,5]='╚═╝     ╚═╝'

    GLYPHS[N,0]='███╗   ██╗'
    GLYPHS[N,1]='████╗  ██║'
    GLYPHS[N,2]='██╔██╗ ██║'
    GLYPHS[N,3]='██║╚██╗██║'
    GLYPHS[N,4]='██║ ╚████║'
    GLYPHS[N,5]='╚═╝  ╚═══╝'

    GLYPHS[O,0]=' ██████╗ '
    GLYPHS[O,1]='██╔═══██╗'
    GLYPHS[O,2]='██║   ██║'
    GLYPHS[O,3]='██║   ██║'
    GLYPHS[O,4]='╚██████╔╝'
    GLYPHS[O,5]=' ╚═════╝ '

    GLYPHS[P,0]='██████╗ '
    GLYPHS[P,1]='██╔══██╗'
    GLYPHS[P,2]='██████╔╝'
    GLYPHS[P,3]='██╔═══╝ '
    GLYPHS[P,4]='██║     '
    GLYPHS[P,5]='╚═╝     '

    GLYPHS[Q,0]=' ██████╗ '
    GLYPHS[Q,1]='██╔═══██╗'
    GLYPHS[Q,2]='██║   ██║'
    GLYPHS[Q,3]='██║▄▄ ██║'
    GLYPHS[Q,4]='╚██████╔╝'
    GLYPHS[Q,5]=' ╚══▀▀═╝ '

    GLYPHS[R,0]='██████╗ '
    GLYPHS[R,1]='██╔══██╗'
    GLYPHS[R,2]='██████╔╝'
    GLYPHS[R,3]='██╔══██╗'
    GLYPHS[R,4]='██║  ██║'
    GLYPHS[R,5]='╚═╝  ╚═╝'

    GLYPHS[S,0]='███████╗'
    GLYPHS[S,1]='██╔════╝'
    GLYPHS[S,2]='███████╗'
    GLYPHS[S,3]='╚════██║'
    GLYPHS[S,4]='███████║'
    GLYPHS[S,5]='╚══════╝'

    GLYPHS[T,0]='████████╗'
    GLYPHS[T,1]='╚══██╔══╝'
    GLYPHS[T,2]='   ██║   '
    GLYPHS[T,3]='   ██║   '
    GLYPHS[T,4]='   ██║   '
    GLYPHS[T,5]='   ╚═╝   '

    GLYPHS[U,0]='██╗   ██╗'
    GLYPHS[U,1]='██║   ██║'
    GLYPHS[U,2]='██║   ██║'
    GLYPHS[U,3]='██║   ██║'
    GLYPHS[U,4]='╚██████╔╝'
    GLYPHS[U,5]=' ╚═════╝ '

    GLYPHS[V,0]='██╗   ██╗'
    GLYPHS[V,1]='██║   ██║'
    GLYPHS[V,2]='██║   ██║'
    GLYPHS[V,3]='╚██╗ ██╔╝'
    GLYPHS[V,4]=' ╚████╔╝ '
    GLYPHS[V,5]='  ╚═══╝  '

    GLYPHS[W,0]='██╗    ██╗'
    GLYPHS[W,1]='██║    ██║'
    GLYPHS[W,2]='██║ █╗ ██║'
    GLYPHS[W,3]='██║███╗██║'
    GLYPHS[W,4]='╚███╔███╔╝'
    GLYPHS[W,5]=' ╚══╝╚══╝ '

    GLYPHS[X,0]='██╗  ██╗'
    GLYPHS[X,1]='╚██╗██╔╝'
    GLYPHS[X,2]=' ╚███╔╝ '
    GLYPHS[X,3]=' ██╔██╗ '
    GLYPHS[X,4]='██╔╝ ██╗'
    GLYPHS[X,5]='╚═╝  ╚═╝'

    GLYPHS[Y,0]='██╗   ██╗'
    GLYPHS[Y,1]='╚██╗ ██╔╝'
    GLYPHS[Y,2]=' ╚████╔╝ '
    GLYPHS[Y,3]='  ╚██╔╝  '
    GLYPHS[Y,4]='   ██║   '
    GLYPHS[Y,5]='   ╚═╝   '

    GLYPHS[Z,0]='███████╗'
    GLYPHS[Z,1]='╚══███╔╝'
    GLYPHS[Z,2]='  ███╔╝ '
    GLYPHS[Z,3]=' ███╔╝  '
    GLYPHS[Z,4]='███████╗'
    GLYPHS[Z,5]='╚══════╝'

    GLYPHS[_,0]='        '
    GLYPHS[_,1]='        '
    GLYPHS[_,2]='        '
    GLYPHS[_,3]='        '
    GLYPHS[_,4]='███████╗'
    GLYPHS[_,5]='╚══════╝'

    GLYPHS[' ',0]='   '
    GLYPHS[' ',1]='   '
    GLYPHS[' ',2]='   '
    GLYPHS[' ',3]='   '
    GLYPHS[' ',4]='   '
    GLYPHS[' ',5]='   '

    GLYPHS[0,0]=' ██████╗ '
    GLYPHS[0,1]='██╔═████╗'
    GLYPHS[0,2]='██║██╔██║'
    GLYPHS[0,3]='████╔╝██║'
    GLYPHS[0,4]='╚██████╔╝'
    GLYPHS[0,5]=' ╚═════╝ '

    GLYPHS[1,0]=' ██╗'
    GLYPHS[1,1]='███║'
    GLYPHS[1,2]='╚██║'
    GLYPHS[1,3]=' ██║'
    GLYPHS[1,4]=' ██║'
    GLYPHS[1,5]=' ╚═╝'

    GLYPHS[2,0]='██████╗ '
    GLYPHS[2,1]='╚════██╗'
    GLYPHS[2,2]=' █████╔╝'
    GLYPHS[2,3]='██╔═══╝ '
    GLYPHS[2,4]='███████╗'
    GLYPHS[2,5]='╚══════╝'

    GLYPHS[3,0]='██████╗ '
    GLYPHS[3,1]='╚════██╗'
    GLYPHS[3,2]=' █████╔╝'
    GLYPHS[3,3]=' ╚═══██╗'
    GLYPHS[3,4]='██████╔╝'
    GLYPHS[3,5]='╚═════╝ '

    GLYPHS[4,0]='██╗  ██╗'
    GLYPHS[4,1]='██║  ██║'
    GLYPHS[4,2]='███████║'
    GLYPHS[4,3]='╚════██║'
    GLYPHS[4,4]='     ██║'
    GLYPHS[4,5]='     ╚═╝'

    GLYPHS[5,0]='███████╗'
    GLYPHS[5,1]='██╔════╝'
    GLYPHS[5,2]='███████╗'
    GLYPHS[5,3]='╚════██║'
    GLYPHS[5,4]='███████║'
    GLYPHS[5,5]='╚══════╝'

    GLYPHS[6,0]=' ██████╗ '
    GLYPHS[6,1]='██╔════╝ '
    GLYPHS[6,2]='███████╗ '
    GLYPHS[6,3]='██╔═══██╗'
    GLYPHS[6,4]='╚██████╔╝'
    GLYPHS[6,5]=' ╚═════╝ '

    GLYPHS[7,0]='███████╗'
    GLYPHS[7,1]='╚════██║'
    GLYPHS[7,2]='    ██╔╝'
    GLYPHS[7,3]='   ██╔╝ '
    GLYPHS[7,4]='   ██║  '
    GLYPHS[7,5]='   ╚═╝  '

    GLYPHS[8,0]=' █████╗ '
    GLYPHS[8,1]='██╔══██╗'
    GLYPHS[8,2]='╚█████╔╝'
    GLYPHS[8,3]='██╔══██╗'
    GLYPHS[8,4]='╚█████╔╝'
    GLYPHS[8,5]=' ╚════╝ '

    GLYPHS[9,0]=' █████╗ '
    GLYPHS[9,1]='██╔══██╗'
    GLYPHS[9,2]='╚██████║'
    GLYPHS[9,3]=' ╚═══██║'
    GLYPHS[9,4]=' █████╔╝'
    GLYPHS[9,5]=' ╚════╝ '
}

# Generate ASCII banner for given text
# Args: $1 - text to convert (will be uppercased)
#       $2 - optional prefix (default: "//")
generate_banner() {
    local text="$1"
    local prefix="${2:-//}"

    # Convert to uppercase
    text=$(echo "$text" | tr '[:lower:]' '[:upper:]')

    # Initialize glyphs
    init_glyphs

    # Build 6 lines
    local lines=("" "" "" "" "" "")

    # Process each character
    for (( i=0; i<${#text}; i++ )); do
        local char="${text:$i:1}"

        # Add each line of the character
        for line in {0..5}; do
            if [[ -n "${GLYPHS[$char,$line]}" ]]; then
                lines[$line]+="${GLYPHS[$char,$line]}"
            else
                # Use space if character not found
                lines[$line]+="${GLYPHS[' ',$line]}"
            fi
        done
    done

    # Output with prefix
    for line in "${lines[@]}"; do
        echo "$prefix $line"
    done
}

# If script is executed directly (not sourced), generate banner from args
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <text> [prefix]"
        echo "Example: $0 'ARCANE SERVER' '//'"
        exit 1
    fi

    generate_banner "$@"
fi