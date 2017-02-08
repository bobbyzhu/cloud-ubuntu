#!/usr/bin/env python
#
# generate-records.py -- generate records.html for noVNC recordings in /noVNC/recordings/
#

import sys, os

mypath = os.path.dirname(os.path.abspath(sys.argv[0]))
sys.path.append(mypath)

from records import *

def main():
    r = Records(record_dir = "noVNC/recordings/")

    r.generate()

main()
