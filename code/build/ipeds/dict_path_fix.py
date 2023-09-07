#################################################################################
# Authors:          Jim Shen
# Task:             Fix IPEDS supplied do files
#   1. Replace the original insheet path with the path for this project
#   2. Don't run the summarize and tab commands
#   3. Don't save the labeled data separately as a Stata
#   4. Fix issue with hd2020 file trying to label strings
#   5. Renames and moves the original do file to raw data/code folder
#   6. Keep fixed file in code folder
# Do Files Used:    All do files downloaded by download.do
# Created:          2023-09-06
# Modified:         2023-09-06
################################################################################
# Notes: Supply two arguments when calling from Stata
# Arg1: name of the do file to modify
# Arg2: location to move the original do file to (project/data/raw/code)
################################################################################

import sys, os

# arguments from command line
fileInput = sys.argv[1]
archiveFolder = sys.argv[2]

# open do files
f1 = open(fileInput+".do",'r')
f2 = open(fileInput+"_fix.do", 'w')

# strings that we are looking for and replacing with

rawpath = 'insheet'
fixpath = 'import delimited "${raw}/'+fileInput+'.csv", clear\n'

labeldata = 'label data '
save = 'save dct'
stabbr = 'label_stabbr'
label_act = 'label_act'
summarize = 'summarize '
tab = 'tab '

# Find and replace lines of code
for line in f1:
    if rawpath in line:
        f2.write(fixpath)
    elif tab in line or summarize in line or labeldata in line or save in line or stabbr in line or label_act in line:
        f2.write("*"+line)
    else:
        f2.write(line)

#close out files and rename/move them
f1.close()
f2.close()

os.rename(fileInput+".do", archiveFolder+"/"+fileInput+"_raw.do")
os.rename(fileInput+"_fix.do",fileInput+".do")