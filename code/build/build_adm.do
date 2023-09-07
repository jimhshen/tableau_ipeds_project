********************************************************************************
* Authors:          Jim Shen
* Task:             Build admissions
* Data Used:        IPEDS ADM
* Created:          2023-09-04
* Modified:         2023-09-04
********************************************************************************
*  Append all of the datasets and keep only the subset of variables used 
*  for the visualization/dashboard
********************************************************************************

    clear
    
* Local variables

	local year_min = 2018
	local year_max = 2021
	
* ****************************************************************
* 1. Opening & appending files
* ****************************************************************

	forvalues year = `year_min'(1)`year_max' {
        quietly: do "$ipeds_do/adm`year'"
		gen year=`year'
		tempfile adm`year'
		save `adm`year''
	}

	clear
	forvalues year = `year_min'(1)`year_max' { 
		append using `adm`year''
	}

* ****************************************************************
* 2. Keep variables and sample of interest
* ****************************************************************
        
   drop admcon1 admcon2 admcon3 admcon4 admcon5 admcon6 admcon7 admcon8 admcon9 ///
   satnum satpct actnum actpct x*

* ****************************************************************
* 3. Update labels
* ****************************************************************
    
    label var enrlm "Enrolled men"
    label var enrlw "Enrolled women"
    label var satvr25 "SAT Reading and Writing 25th percentile score"
    label var satvr75 "SAT Reading and Writing 75th percentile score"
   
    save "${build_data}/adm.dta", replace
   