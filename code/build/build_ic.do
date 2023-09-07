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
* ****************************************************************

    keep unitid slo5 slo6 cntlaffi year
    label var cntlaffi "Religious Institution"
    
    label define label_cntlaffi2 1 "No"
    label define label_cntlaffi2 2 "No",add
    label define label_cntlaffi2 3 "No",add
    label define label_cntlaffi2 4 "Religious",add
    label values cntlaffi label_cntlaffi2
    rename cntlaffi religious
    
    save "${build_data}/ic.dta", replace