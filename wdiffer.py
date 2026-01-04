#!/usr/bin/env python3
# Name: wdiffer.py
# Author: Rob Toscani
# Date: 19-12-2025
# Description: Private version of wdiff() as a Python3 script.
# Alternative for the standard UNIX wdiff() utility.
# It displays word differences between two plain text files.
#
#     Usage: wdiffer.py [OPTIONS] textfile1 textfile2
#
# Following options are available: -h, -w, -x, -y and -z (see man wdiff)
# pypy can be used to further enhance speed.
#
# This program is based on the 'Longest Common Subsequence' (LCS) algorithm
# as laid out in:
# https://en.wikipedia.org/wiki/Longest_common_subsequence
#
# LeChat Mistral (AI) has been used to convert the *recursive* printDiff() function
# from above source into the similarly named *iterative* version used below.
#
# Opmerking:
# Hier wordt elk apart woord nog gemarkeerd als een eigen delete- of insert-region,
# in plaats van de aaneengeschakelde groep waartoe die woorden behoren.
# Dit wijkt dus qua gedrag af van wdiff(), maar geeft bij kleurcodering
# geen afwijkend visueel effect.
#
#####################################################################################
#
# Copyright (C) 2025 Rob Toscani <rob_toscani@yahoo.com>
#
# wdiffer.py is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# wdiffer.py is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
######################################################################################

import sys
import getopt

# Initialize all output words lists:
start_text = []
diff_text  = []
end_text   = []

# Initialize strings marking beginning and end of insert- en delete-regions:
start_delete = ""
end_delete   = ""
start_insert = ""
end_insert   = ""

# Text printed if -h option (help) or a non-existent option has been given:
usage = """
Usage:
wdiffer.py [OPTION(S)]  FILE1  FILE2
\t-h          Help (this output)
\t-w STRING   String to mark beginning of delete region
\t-x STRING   String to mark end of delete region
\t-y STRING   String to mark beginning of insert region
\t-z STRING   String to mark end of insert region
"""

# Select option(s):
try:
    options, non_option_args = getopt.getopt(sys.argv[1:], 'hw:x:y:z:')
except:
    print(usage)
    sys.exit()

for opt, arg in options:
    if opt in ('-h'):
        print(usage)
        sys.exit()
    elif opt in ('-w'):
        start_delete = str(arg)
    elif opt in ('-x'):
        end_delete = str(arg)
    elif opt in ('-y'):
        start_insert = str(arg)
    elif opt in ('-z'):
        end_insert = str(arg)

if len(non_option_args) < 2:
    print("Files are missing as an argument!", file=sys.stderr)
    sys.exit()

# Both text files:
file1 = non_option_args[0]
file2 = non_option_args[1]

# Populate the LCS-Matrix:
def populateMatrix(words1, words2):
    m=len(words1)-1
    n=len(words2)-1
    m_bound = m+1
    n_bound = n+1
    for i in range(0,m_bound):
        M[i][0] = 0
    for j in range (0,n_bound):
        M[0][j] = 0
    for i in range(1,m_bound):
        x = i - 1
        for j in range(1,n_bound):
            y = j - 1
            if words1[i] == words2[j]:
                M[i][j] = M[x][y] + 1
            else:
                M[i][j] = max(M[i][y], M[x][j])

# Execute the LCS algorithm and store results to diff-words list in reverse reading order:
def printDiff(M, words1, words2):
    stack = []
    stack.append((len(words1)-1, len(words2)-1))  # Start from the end of both texts

    while stack:
        i, j = stack.pop()
        x = i - 1
        y = j - 1

        if i >= 0 and j >= 0 and words1[i] == words2[j]:
            stack.append((x, y))
            # We print after popping, so the order is preserved
            if not stack:
                diff_text.append(words1[i])   # Diff output words list
            else:
                # Defer printing until after the recursive call
                stack.append(("print", words1[i]))
        elif j > 0 and (i == 0 or M[i][y] >= M[x][j]):
            stack.append((i, y))
            if not stack or stack[-1][0] != "print":
                stack.append(("print", start_insert + words2[j] + end_insert))
        elif i > 0 and (j == 0 or M[i][y] < M[x][j]):
            stack.append((x, j))
            if not stack or stack[-1][0] != "print":
                stack.append(("print", start_delete + words1[i] + end_delete))
        else:
            if not stack or stack[-1][0] != "print":
                stack.append(("print", ""))

        # Print all deferred messages
        while stack and stack[-1][0] == "print":
            _, msg = stack.pop()
            if msg:
                diff_text.append(msg)   # Diff output words list

# Store file1 into words1 list:
with open(file1) as f:
    words1 = [word for line in f for word in line.split()+["\n"]]

# Store file2 into words2 list:
with open(file2) as f:
    words2 = [word for line in f for word in line.split()+["\n"]]

# Maximum number of matching words at beginning and end that can be stripped:
striplength = min(len(words1), len(words2))

# Store matching text at the beginning into start_text list (to be excluded from Matrix):
i = 0
boundary = striplength
for i in range(0, boundary):
    if words1[i] == words2[i]:
        start_text.append(words1[i])
        striplength -= 1
    else:
        break

# Store matching text at the end into end_text list (to be excluded from Matrix):
i = -1
while striplength > 0:
    if words1[i] == words2[i]:
        end_text.append(words1[i])   # N.B.: this is a reverted list!
        i -= 1
        striplength -= 1
    else:
        break

# Trim words1 and words2 by omitting matching text lists at beginning & end:
words1[:] = [ "" ] + words1[len(start_text) : len(words1) - len(end_text)]
words2[:] = [ "" ] + words2[len(start_text) : len(words2) - len(end_text)]

# Initialize the LCS-Matrix:
M = [ [ y for y in range(0,len(words2))] for x in range(0,len(words1)) ]

# Populate the LCS-Matrix:
populateMatrix(words1, words2)

# Execute the LCS algorithm:
printDiff(M, words1, words2)

# Revert diff_text and end_text lists to achieve correct word order (= reading order):
diff_text.reverse()
end_text.reverse()

# Send all output words lists to stdout as a text stream:
for word in start_text + diff_text + end_text:
    if not (word == "\n" or word == "" or word == "\r" or word == "\r\n"):
        print(word, end=' ')
    else:
        print()
