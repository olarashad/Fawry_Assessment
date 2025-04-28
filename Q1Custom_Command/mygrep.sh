#!/bin/bash

print_help() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo ""
    echo "Options:"
    echo "  -n        Display line numbers for matches"
    echo "  -v        Invert the match to show non-matching lines"
    echo "  --help    Show this help message :)"
}


if [ $# -eq 0 ]; then
    echo "error: no input provided."
    print_help
    exit 1
fi


show_numbers=false
invert=false


while getopts "nv-" opt; do
    case "$opt" in
        n) show_numbers=true ;;
        v) invert=true ;;
        -)
            case "$OPTARG" in
                help) print_help; exit 0 ;;
                *) echo "unknown option: --$OPTARG :("; print_help; exit 1 ;;
            esac ;;
        :) echo "option -$OPTARG requires an argument."; exit 1 ;;
        \?) echo "invalid option: -$OPTARG"; exit 1 ;;
    esac
done

shift $((OPTIND - 1))

if [ $# -lt 2 ]; then
    echo "error: missing search string or file name :("
    print_help
    exit 1
fi

word="$1"
file="$2"


if [ ! -f "$file" ]; then
    echo "error: cannot find file '$file'."
    exit 2
fi


cmd="grep -i"
 
if [ "$invert" = true ]; then
    cmd="$cmd -v"
fi

if [ "$show_numbers" = true ]; then
    cmd="$cmd -n"
fi








$cmd -- "$word" "$file"
