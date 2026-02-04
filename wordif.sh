#!/bin/bash
# Name: wordif.sh
# Author: Rob Toscani
# Date: 7th Januari 2026
# Description: This program performs word-by-word comparison between
# two plain-text-files.
# It is a wrapper-script around 'diff()', and serves as an alternative
# for wdiff() (https://www.gnu.org/software/wdiff/).
#
# It can function in two modes:
# Either:
#     a. (default) one single comparison between given two text-files,
# or:
#     b. (optionally) multiple comparison of all pairs of text-files
#         with equally numbered name, shared by given two directories.
#
# The results are stored as color-marked difference-files in HTML-,
# or (optionally) PDF-format, or (optionally) sent to stdout in HTML-format.
#
# Prerequisite:
# - wkhtmltopdf (if output to PDF is desired)
#
# (The script 'shufflewords.sh' can be used to stress-test this program.)
#
#####################################################################################
#
# Copyright (C) 2026 Rob Toscani <rob_toscani@yahoo.com>
#
# wordif.sh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# wordif.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
######################################################################################

# Default arguments:
args="files"

# Default deletion- and insertion-colors:
delhex="ff0000"
inshex="00ff00"

# Escape < and > to prevent interpretation as HTML-syntax (tags):
esc_html="s/</\&lt;/g; s/>/\&gt;/g"

# The HTML-tags to be pasted underneath the text:
html_coda="
</pre>
</body>
</html>"

# Standard output-directory:
outputdir="./"

# Standard output-format:
format="html_file"

# Standard character font:
font="\"Courier New\", monospace"

# Standard character size:
size=12


# FUNCTIONS:
# ==========

options(){
# Specify options:
    while getopts "c:C:df:hopz:" OPTION; do
        case $OPTION in
            c) if grep -qE "^[0-9a-fA-F]{6}$" <(echo "$OPTARG"); then
                   delhex="$OPTARG"
               else
                   helptext && exit 1
               fi
               ;;
            C) if grep -qE "^[0-9a-fA-F]{6}$" <(echo "$OPTARG"); then
                   inshex="$OPTARG"
               else
                   helptext && exit 1
               fi
               ;;
            d) args="directories"
               ;;
            f) if   [[ $OPTARG == H ]]; then font="\"Helvetica\", sans-serif"
               elif [[ $OPTARG == h ]]; then font="\"Helvetica Narrow\", sans-serif" 
               elif [[ $OPTARG == c ]]; then font="\"Courier\", monospace"
               elif [[ $OPTARG == n ]]; then font="\"New Century Schoolbook\", serif"
               elif [[ $OPTARG == p ]]; then font="\"Palatino\", serif"
               elif [[ $OPTARG == T ]]; then font="\"Times New Roman\", serif"
               elif [[ $OPTARG == t ]]; then font="\"Times\", serif"
               else                          font="\"Courier New\", monospace"
               fi
               ;;
            h) helptext
               exit 0
               ;;
            o) if [[ $format !=  "pdf_file" ]]; then
                   format="html_stdout"
               fi
               ;;
            p) format="pdf_file"
               ;;
            z) if grep -qE "^[[:digit:]]*\.?[[:digit:]]+$" <<<"$OPTARG"; then
                   size=$OPTARG
               else
                   helptext && exit 1
               fi
               ;;
            *) helptext
               exit 1
               ;;
        esac
    done
}

helptext()
# Text printed if -h option (help) or a non-existent option has been given:
{
    while read "line"; do
        echo "$line" >&2         # print to standard error (stderr)
    done << EOF
Usage:
|        wordif.sh   [OPTIONS]  FILE1       FILE2
|        wordif.sh -d[OPTIONS]  DIRECTORY1  DIRECTORY2
|
-h       Help (this output)
-c RGBHEX
|         Specify 'deleted-text' color by 6-digit rgb hex-value (default: ff0000 [red])
-C RGBHEX
|        Specify 'inserted-text' color by 6-digit rgb hex-value (default: 00ff00 [green])
-d       Specify two directories as arguments rather than two files;
|        Compare each file in directory2 to the equally unique-numbered file in directory1
-f FONT
|        Character-font instead of default Courier New:
|        FONT  = H   Helvetica
|                h   Helvetica Narrow
|                c   Courier
|                n   New Century Schoolbook
|                p   Palatino
|                T   Times New Roman
|                t   Times
-o       Send HTML-text to stdout rather than to file
-p       Convert HTML-text and save to PDF-file; this option overrides option -o
-z SIZE
|        Character size in pts as a replacement for 12 pts.
|        Also accepts values with decimal point.
EOF
}

numberlist()
# Print a ('horizontal') list of the leading numbers in the file names in given directory:
{
    ls "$1"           |
    grep -oE ^[0-9]+_ |
    tr '_' ' '        |
    sort -n           |
    tr -d '\n'        |
    sed 's/ $//'
}

checkrepeat()
# Detect any repetitions in a sorted number list, and issue a warning if found:
{
    repeatnum="$(grep -oE "(\<[0-9]+\>) \1" <<< "$1")"
    if [[ -n "$repeatnum" ]]; then
        qty=$(wc -w <<< "$repeatnum")
        num=${repeatnum/ */}
        echo "WARNING: Number $num appears in $qty file-names in the $2." >&2
        echo "Only one file with $num was compared with a (possibly wrong) file in the $3." >&2
    fi
}

print_html_intro()
# Print the HTML-tags to be pasted above the text:
{
    intro="
<!DOCTYPE html>
<html>
<head>
<meta charset=\"utf8\">
<style type=\"text/css\">
pre {
  font-family: "$font";
  font-size:   "$size"pt;
  white-space: pre-wrap;
  white-space: -moz-pre-wrap;
  white-space: -pre-wrap;
  white-space: -o-pre-wrap;
  white-space: -webkit-pre-wrap;
  word-wrap:   break-word;
}
</style>
<title>$1</title>
</head>
<body>
<pre>"
    echo "$intro"
}

splitwords()
# Place all words on a separate line, while preserving original newlines, spaces and tabs:
{
    awk '{
        gsub(/^/, "\b")       # Place backspace at beginning of line as to mark original "new line"
        gsub(/ /, "\n")       # Replace space by newline, putting each word on a separate line
        gsub(/\t/, "\n\t\n")  # Put tab (tabulation) on a separate line as to treat it like a word
        print
    }' "$1"
}

joinwords()
# Place all words on the same line again, restore original newlines and remove temporarily added spaces:
{
    # Regex-group of a series of html color-tags as a string variable:
    taggroup="((($delete_start|$insert_start|$end)?)*)"
    # Restore original spaces from each temporary newline (adding some temporary spaces in the process):
    tr '\n' ' ' |
    # Restore original newlines from each temporary backspace:
    awk '{ gsub(/\b/, "\n"); print }' - |
    # Remove all temporarily added single spaces: around each tab and trailing:
    sed -E $'s_ '"$taggroup"'\t'"$taggroup"' _\1\t\2_g;
             s_ '"$taggroup"'$_\1_'
}

makediff()
# Perform text comparison between two text files, and store the output in desired format:
{
    NUMBER="$3"
    if  [[ $args == "directories" ]]; then
        # If option = -d (directories), derive both file names from given directories and <NUMBER>:
        file1="$(ls $1/$NUMBER"_"* 2>/dev/null | head -n 1)"
        file2="$(ls $2/$NUMBER"_"* 2>/dev/null | head -n 1)"

        # Do nothing if a <NUMBER> is missing. and issue warning if it misses in one directory only:
        if ([[ -z "$file1" ]] || [[ -z "$file2" ]]); then
            if [[ -n "$file1" ]]; then
                echo "WARNING: Number $NUMBER appears in 1st directory only, not in 2nd directory." >&2
            elif [[ -n "$file2" ]]; then
                echo "WARNING: Number $NUMBER appears in 2nd directory only, not in 1st directory." >&2
            fi
            return
        fi
    else
        file1="$1"
        file2="$2"
    fi

    (print_html_intro "$file2"

    # Compare both files to each other and generate color-marked difference-file:
    diff -B --strip-trailing-cr                   \
         --old-group-format="$delete_start%<$end" \
         --new-group-format="$insert_start%>$end" \
         --unchanged-group-format='%='            \
          <(sed "$esc_html" "$file1" | splitwords - ) \
          <(sed "$esc_html" "$file2" | splitwords - ) |

    joinwords -

    echo "$html_coda") | store2file - $NUMBER
}

store2file()
# Save HTML-text-stream to file, or (option -o) catenate, or (option -p) convert to PDF-file:
{
    file="$1"
    NUMBER="$2"
    if [[ $format == "html_file" ]]; then
        cat "$file" >| "$outputdir"/"$(date +"%Y%m%d_%H%M")_diff_$NUMBER.html"
    elif [[ $format == "html_stdout" ]]; then
        cat "$file"
    elif [[ $format == "pdf_file" ]]; then
        wkhtmltopdf "$file" "$outputdir"/"$(date +"%Y%m%d_%H%M")_diff_$NUMBER.pdf" 2>/dev/null
    fi
}

htmlcat()
# Send html text-stream to stdout (option -o) while removing all headers except the first one:
{
    awk -v first=1 '{
        if (first){
            print
            if (/^<\/head>/) first = 0
        }
        else{                               # If not the first header
            if (/^<head>/)
                head = 1
            else if (/^<\/head>/)
                head = 0
            else if (! (head || /^<!DOCTYPE/)){
                print
                if (/^<html>/) print "<hr>" # Separation line between present & previous diff-section
            }
        }
    }' "$1"
}


# MAIN FUNCTION:
# ==============

# Execute the options:
options "$@"
shift $(( OPTIND - 1 ))

[[ $# < 2 ]] && echo "Not enough arguments given"  >&2 && exit 1

# The HTML deletion- and insertion-tags:
delete_start="<span style=\"font-weight:bold;color:#$delhex;\">"
insert_start="<span style=\"font-weight:bold;color:#$inshex;\">"
end="</span>"

if [[ $args == "directories" ]]; then

    # Check if given directories exist:
    ([[ ! -d "$1" ]] || [[ ! -d "$2" ]]) && echo "Specify existing directories."  >&2 && exit 1

    # Create the ./diff/-directory, unless it already exists:
    [[ ! -d ./diff ]] && mkdir ./diff
    outputdir="./diff"

    # Create a list with all <NUMBER> values for each of the two directories:
    list1="$(numberlist "$1")"
    list2="$(numberlist "$2")"

    # Check if the <NUMBER>-lists contain any repetitions, and if so issue a warning:
    checkrepeat "$list1" "1st directory" "2nd directory"
    checkrepeat "$list2" "2nd directory" "1st directory"

    # Determine the maximum <NUMBER> value appearing in any of the sorted lists:
    max1=${list1/* /}
    max2=${list2/* /}
    (( max1 > max2 )) && max=$max1 || max=$max2

    # While incrementing from 0 to max value, call makediff() function with <NUMBER> argument:
    NUMBER=0
    while (( NUMBER <= max )); do
        makediff "$1" "$2" $NUMBER
        (( NUMBER += 1 ))
    done | htmlcat -        # Send to stdout in case of option -o to be handled further by
                            # e.g. 'bcat()' or any other "pipe2browser" program.
    # Conclusion:
    [[ $format != "html_stdout" ]] && echo "READY! - Please find all results in $(pwd)/diff/" >&2

else
    # In case of files instead of directories as arguments:
    if [[ -f  "$1" ]] && [[ -f "$2" ]]; then
        makediff "$1" "$2"
    else
        echo "ERROR: Specify existing files and no directories" >&2
        exit 1
    fi
fi
