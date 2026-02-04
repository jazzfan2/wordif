# Name: wordif.sh
wordif.sh  - compares plain-text-files word-by-word, and stores color-marked results in HTML-format.

# Description:
'wordif.sh' is a wrapper script around the UNIX diff() utility.

It performs word-by-word comparison of one or multiple pair(s) of plain-text-files, in very much the same
way as the UNIX wdiff() utility.
Results are stored as color-marked difference-files in HTML-format, or in PDF-format if option -p is given.

A difference-file is a unification of the two input text-files, preserving original text sequence.
Text present in both files is printed in black. (Groups of) words locally missing in one of the two files
are color-marked as follows:
- bolt red text is present in the 1st file, and not present (there) in the 2nd file;
- bolt green text is present in the 2nd file and not present (there) in the 1st file;

With option -d, wordif.sh acts on two directories instead of two text-files.
It then compares each text-file in the 2nd directory to its associated text-file in the 1st directory.
The resulting difference-files are collected in a difference-directory.

To correctly associate two files in either directory to each other, their respective file names must
start with same unique number, followed by an underscore.

# How to use wordif.sh:
Usage:

	wordif.sh   [OPTIONS]  FILE1       FILE2
	          -d[OPTIONS]  DIRECTORY1  DIRECTORY2

Options:

	-h       Help (this output)
    -c RGBHEX
             Specify 'deleted-text' color by 6-digit hexadecimal rgb-value (default: ff0000 [red])
    -C RGBHEX
             Specify 'inserted-text' color by 6-digit hexadecimal rgb-value (default: 00ff00 [green])
	-d       Specify two directories as arguments instead of two text-files;
	         Compare each file in directory2 to the equally unique-numbered file in directory1
    -f FONT
             Character-font instead of default Courier New:
             FONT  = H   Helvetica
                     h   Helvetica Narrow
                     c   Courier
                     n   New Century Schoolbook
                     p   Palatino
                     T   Times New Roman
                     t   Times
    -o       Send HTML-text to stdout rather than to file
    -p       Output as PDF- instead of HTML-files; this option overrides option -o
    -z SIZE
             Character size in pts (default 12 pts). Also accepts values with decimal point. 


# Author:
wordif.sh has been written by Rob Toscani (rob_toscani@yahoo.com).
If you find any bugs or want to comment otherwise, please let me know.
