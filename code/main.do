********************************************************************************
* Authors:          Jim Shen
* Task:             Setup File
* Do Files Used:    setup.do
*                   download.do
*
* Created:          2023-09-04
* Modified:         2023-09-04
********************************************************************************
*  Sets globals, installs packages
********************************************************************************

* Settings

	clear all
	set more off
	set maxvar 32000
	set matsize 11000
	set trace off
	set tracedepth 1
	pause on
	version 18.0
	
* Run Setup
	global setup_path   "C:/Users/Jim/Documents/GitHub/tableau_ipeds_project/code"
    
	do "${setup_path}/setup.do"
    
* Switches

    local download           0
    local build 			 1

* Run each Master file

    if `download' 				do "${code}/download.do"
    if `build' 				    do "${build_code}/build.do"
