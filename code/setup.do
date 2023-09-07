********************************************************************************
* Authors:          Jim Shen
* Task:             Setup File
* Do Files Used:    download.do
*
* Created:          2023-09-04
* Modified:         2023-09-04
********************************************************************************
*  Sets globals, creates folders, installs packages
********************************************************************************

* Global Locations

    global user `c(username)'
    
    //global root "C:/Users/${user}/Dropbox"
    global root         "D:/Google Drive"

    global path         "${root}/Tableau/ipeds_project"
    
    global code         "${path}/code"
    global build_code   "${code}/build"
    global ipeds_do     "${code}/build/ipeds"
    
    global ado          "${path}/code/ado"
    global ado_plus     "${path}/code/ado/plus"
    global ado_personal "${path}/code/ado/personal"
    
    global data         "${path}/data"
    global raw          "${data}/raw"
    global raw_code     "${raw}/code"
    global doc          "${raw}/documentation"
    global build_data   "${data}/build"
    global clean_data   "${data}/clean"
    global output       "${path}/output"
    
    global nces_src     "https://nces.ed.gov/ipeds/datacenter/data"

	cd "$path"
	
* Create Directories if needed

    local dirs `" "$ado" "$ado_plus" "$ado_personal" "$ado_personal" "$code" "$build_code" "$ipeds_do" "$data" "$raw" "$doc" "$raw_code" "$clean_data"  "$output" "'

    di `dirs'
    foreach dir in `dirs' {

      *** Check if directory exists
      mata : st_numscalar("exists", direxists("`dir'"))

      *** If not, create directory
      if scalar(exists) == 0        mkdir "`dir'"
    }

* Set system ado folders accordingly
 
    sysdir set PLUS       "$ado_plus"
    sysdir set PERSONAL   "$ado_personal"
    net set ado           "$ado_plus"