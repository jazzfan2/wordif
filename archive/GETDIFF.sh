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

# Best solution:
myloc="$(realpath "$(dirname $0)")"
cd "$myloc"

./wordif.sh -d oud nieuw