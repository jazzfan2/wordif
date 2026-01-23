#!/usr/bin/env python
# Naam: GETDIFF.py
# Opgesteld: Rob Toscani
# Datum: 21-01-2026
# Beschrijving:
# Voer het lokale programma 'wordif.sh' uit op de lokale directories 'oud/' en 'nieuw/'
# ('knop'-onderdeel in de directory 'WORDIF')
#
#######################################################################################

import os

dirpath = os.path.dirname( __file__ )    # De locatie van dit python-script

os.system('cd \"' + dirpath + '\"; ./wordif.sh -d ./oud ./nieuw')
