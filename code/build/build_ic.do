********************************************************************************
* Authors:          Jim Shen
* Task:             Build insitutional characteristics - other
* Data Used:        IPEDS IC
* Created:          2023-09-04
* Modified:         2023-09-04
********************************************************************************
*  Append all of the datasets and keep only the subset of variables used 
*  for the visualization/dashboard
********************************************************************************

    clear
    
* Local variables

	local year_min = 2017
	local year_max = 2021
	
* ****************************************************************
* 1. Opening & appending files
* ****************************************************************

	forvalues year = `year_min'(1)`year_max' {
        quietly: do "$ipeds_do/ic`year'"
		gen year=`year'
		tempfile ic`year'
		save `ic`year''
	}

	clear
	forvalues year = `year_min'(1)`year_max' { 
		append using `ic`year'', force
	}
    
* ****************************************************************
* 2. Keep variables of interest
* ***************************************************************
    
    gen religious=1 if cntlaffi==4
    replace religious=0 if religious==.
    
    gen rotc=1 if slo5==1
    replace rotc=0 if rotc==.
    
    gen abroad=1 if slo6==1
    replace abroad=0 if abroad==.
    
    label var religious "Religious Institution"
    label var rotc "Has ROTC program"
    label var abroad "Has study abroad program"
    
    keep unitid year religious rotc abroad

    save "${build_data}/ic.dta", replace