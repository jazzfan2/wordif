#!/bin/sh
# Name: GETDIFF.sh
# Author: Rob Toscani
# Date: 21-03-2026
# Description:
# Run the local program 'wordif.sh' on local directories 'oud/' and 'nieuw/'
# ('button'-component within the 'WORDIF' directory).
#
#######################################################################################

# Only if this script itself - not a symlink to it - is in 'WORDIF':
# myloc="$(dirname "$(realpath $0)")"

# Otherwise, if realpath -s is available (not on BSD-like systems!):
# myloc="$(dirname "$(realpath -s $0)")"

# Best solution, not needing the -s option:
# myloc="$(realpath "$(dirname $0)")"

# If realpath() isn't available at all, use Kusalananda's solution in:
# https://unix.stackexchange.com/questions/558350/is-there-in-bash-a-builtin-command-to-get-the-absolute-path-of-a-relative-file
myloc="$( ( OLDPWD=- CDPATH= cd -P -- "$(dirname $0)" && pwd ) )"

cd "$myloc"

./wordif.sh -d oud nieuw