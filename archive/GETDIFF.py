#!/usr/bin/env python
# Name: GETDIFF.py
# Author: Rob Toscani
# Date: 21-01-2026
# Description:
# Run the local program 'wordif.sh' on local directories 'oud/' and 'nieuw/'
# ('button'-component within the 'WORDIF' directory).
#
#######################################################################################

import os

dirpath = os.path.dirname( __file__ )    # The location of this Python script

print(dirpath)

os.system('cd \"' + dirpath + '\"; ./wordif.sh -d ./oud ./nieuw')
