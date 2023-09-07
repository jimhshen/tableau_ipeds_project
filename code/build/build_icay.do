********************************************************************************
* Authors:          Jim Shen
* Task:             Build insitutional characteristics -  tuition
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
        quietly: do "$ipeds_do/ic`year'_ay"
		gen year=`year'
		tempfile ic`year'_ay
		save `ic`year'_ay'
	}

	clear
	forvalues year = `year_min'(1)`year_max' { 
		append using `ic`year'_ay', force
	}
    
* ****************************************************************
* 2. Keep variables and sample of interest
* ****************************************************************

    keep unitid tuition1 tuition2 tuition3 ///
    chg1ay3 chg2ay3 chg3ay3 chg4ay3 chg5ay3 chg6ay3 year
    
    
    save "${build_data}/icay.dta", replace    