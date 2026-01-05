#!/bin/bash
# Name: wdiffer.sh
# Author: Rob Toscani
# Date: 26-12-2025
# Description: Private version of wdiff() as a Bash/GAWK script.
# Alternative for the standard UNIX wdiff() utility.
# It displays word differences between two plain text files.
#
#     Usage: wdiffer.sh [OPTIONS] textfile1 textfile2
#
# Following options are available: -h, -w, -x, -y and -z (see man wdiff)
#
# This program is based on the 'Longest Common Subsequence' (LCS) algorithm
# as laid out in:
# https://en.wikipedia.org/wiki/Longest_common_subsequence
#
# LeChat Mistral (AI) has been used to convert the *recursive* printDiff() function
# from above source into the *iterative* code of the 'while (pointer >= 0)' loop in
# below 'wdiff_function()'.
#
# Version with 'true 2d-arrays' for the LCS-matrix 'M' and the stack.
# Prerequisite:
# - gawk
#
# Bug: the output results don't show any text indents nor multiple spaces/tabs present
# in the original texts.
#
#####################################################################################
#
# Copyright (C) 2025 Rob Toscani <rob_toscani@yahoo.com>
#
# wdiffer.sh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# wdiffer.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
######################################################################################


wdiff_function()
{
    gawk -v start_delete="$start_delete" -v end_delete="$end_delete" \
         -v start_insert="$start_insert" -v end_insert="$end_insert" '\
    function max(a, b){
        if (a >= b)
            return a
        else
            return b
    }

    function min(a, b){
        if (a <= b)
            return a
        else
            return b
    }

    BEGIN {
        split("", words1)
        split("", words2)
        split("", diff_text)
        m = 0
        n = 0
        k = 0
    }

    FNR == NR && ARGV[1] == FILENAME {
        for (f = 1; f <= NF; f++)
             words1[++m] = $f
        words1[++m] = "\n"
        next
    }  {
        for (f = 1; f <= NF; f++)
            words2[++n] = $f
        words2[++n] = "\n"
    }

    END {

        maxmatch = min(m,n)  # Maximum possible number of matching words at beginning and end
        boundary = maxmatch
        p = 0
        for (i = 1; i <= boundary; i++){
            if (words1[i] == words2[i]){
                if (! (words1[i] == "\n" || words1[i] == ""))
                    printf words1[i]" "   # Print matching beginning
                else
                    print ""
                p ++         # Length of matching beginning
                maxmatch --  # Max remaining number of matching words at beginning and end
            }
            else
                break
        }

        i = m
        j = n
        q = 0
        while (maxmatch){
            if (words1[i--] == words2[j--]){
                q ++         # Length of matching end
                maxmatch --  # Max remaining number of matching words at beginning and end
            }
            else
                break
        }

        m = m - q       # Lower end indexes by q, omitting matching text at the end
        n = n - q

        words1[p] = ""  # Raise start index by p, omitting matching text at beginning
        words2[p] = ""

        split("", M)
        for (i = p; i <= m; i++)
            M[i][p] = 0
        for (j = p; j <= n; j++)
            M[p][j] = 0
        i_min = 1+p
        j_min = 1+p
        for (i = i_min; i <= m; i++){
            x = i - 1
            for (j = j_min; j <= n; j++){
                y = j - 1
                if (words1[i] == words2[j])
                    M[i][j] = M[x][y] + 1
                else
                    M[i][j] = max(M[i][y], M[x][j])
            }
        }

        split("", stack)
        stack[0][0] = m
        stack[0][1] = n

        pointer = 0

        while (pointer >= 0){

            i = stack[pointer][0]
            j = stack[pointer][1]
            x = i - 1
            y = j - 1
            pointer--

            if (i >= p && j >= p && words1[i] == words2[j]){
                pointer++
                stack[pointer][0] = x
                stack[pointer][1] = y
                if (pointer < 0)
                    diff_text[k++] = words1[i]
                else{
                    pointer++
                    stack[pointer][0] = "print"
                    stack[pointer][1] = words1[i]
                }
            }
            else if (j > p && (i == p || M[i][y] >= M[x][j])){
                pointer++
                stack[pointer][0] = i
                stack[pointer][1] = y
                if (pointer < 0 || stack[pointer][0] != "print"){
                    pointer++
                    stack[pointer][0] = "print"
                    stack[pointer][1] = start_insert""words2[j]""end_insert
                }
            }
            else if (i > p && (j == p || M[i][y] < M[x][j])){
                pointer++
                stack[pointer][0] = x
                stack[pointer][1] = j
                if (pointer < 0 || stack[pointer][0] != "print"){
                    pointer++
                    stack[pointer][0] = "print"
                    stack[pointer][1] = start_delete""words1[i]""end_delete
                }
            }
            else{
                if (pointer < 0 || stack[pointer][0] != "print"){
                    pointer++
                    stack[pointer][0] = "print"
                    stack[pointer][1] = ""
                }
            }

            while (pointer >= 0 && stack[pointer][0] == "print"){

                msg = stack[pointer][1]
                pointer--

                if (msg)
                    diff_text[k++] = msg
            }
        }

        for (i = k-1; i >= 0; i--){
            if (! (diff_text[i] == "\n" || diff_text[i] == ""))
                printf diff_text[i]" "
            else{
                print ""
            }
        }

        for (i = m+1; i <= m+q; i++){
            if (! (words1[i] == "\n" || words1[i] == ""))
                printf words1[i]" "    # Print matching end
            else{
                print ""
            }
        }

    }' "$1" "$2"
}

options(){
# Specify options:
    while getopts "hw:x:y:z:" OPTION; do
        case $OPTION in
            h) helptext
               exit 0
               ;;
            w) start_delete="$OPTARG"
               ;;
            x) end_delete="$OPTARG"
               ;;
            y) start_insert="$OPTARG"
               ;;
            z) end_insert="$OPTARG"
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
       wdiffer.sh [OPTION(S)]  FILE1  FILE2

|  -h          Help (this output)
|  -w STRING   String to mark beginning of delete region
|  -x STRING   String to mark end of delete region
|  -y STRING   String to mark beginning of insert region
|  -z STRING   String to mark end of insert region
EOF
}

remove_empty_top_end()
# https://unix.stackexchange.com/questions/666539/how-to-remove-empty-lines-at-the-end-of-a-file-using-awk
{
    awk '/^$/ && a!=1 {a=0} !/^$/ {a=1} a==1 {print}' "$1"  |
    awk '/^$/{n=n RS}; /./{printf "%s",n; n=""; print}'
}

start_delete=""
end_delete=""
start_insert=""
end_insert=""

# Execute the options:
options "$@"
shift $(( OPTIND - 1 ))

# Call wdiff_function w/ both files, after removing returns, 
# idle spaces & tabs and empty top & bottom lines:
wdiff_function <(sed -E -e $'s/\r//g; s/^( |\t)*$//' "$1" | remove_empty_top_end -) \
               <(sed -E -e $'s/\r//g; s/^( |\t)*$//' "$2" | remove_empty_top_end -)
