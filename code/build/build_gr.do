********************************************************************************
* Authors:          Jim Shen
* Task:             Build graduation
* Data Used:        IPEDS GR
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
    local totals    grtotlt grtotlm grtotlw graiant graianm graianw grasiat ///
                    grasiam grasiaw grbkaat grbkaam grbkaaw grhispt grhispm ///
                    grhispw grnhpit grnhpim grnhpiw grwhitt grwhitm grwhitw ///
                    gr2mort gr2morm gr2morw grunknt grunknm grunknw grnralt ///
                    grnralm grnralw
	
* ****************************************************************
* 1. Opening & appending files
* ****************************************************************

	forvalues year = `year_min'(1)`year_max' {
        quietly: do "$ipeds_do/gr`year'"
		gen year=`year'
		tempfile gr`year'
		save `gr`year''
	}

	clear
	forvalues year = `year_min'(1)`year_max' { 
		append using `gr`year''
	}
    
* ****************************************************************
* 2. Calculate IPEDS graduation rate
*    Only use total graduation rates for 4 year institutions.
*    Calculated using IPEDS definition of the number of completers
*    within 150% of normal time divided by size of adjusted cohort
* ****************************************************************

    keep if chrtstat==12 | chrtstat==13
    
    keep if grtype==2 | grtype==3 | grtype==29 | grtype==30
    
    drop x* grtype section cohort line
    
    reshape wide `totals', i(unitid year) j (chrtstat)
    
    foreach var in `totals' {
        gen `var'= `var'13/`var'12
    }
    
    drop *12 *13
    
    label variable grtotlm  "GR: Total Men"
    label variable grtotlw  "GR: Total Women"    
    label variable grtotlt  "GR: Total"
    label variable gr2morm  "GR: Two or more races men"
    label variable gr2mort  "GR: Two or more races total"
    label variable gr2morw  "GR: Two or more races women"
    label variable graianm  "GR: American Indian or Alaska Native men"
    label variable graiant  "GR: American Indian or Alaska Native total"
    label variable graianw  "GR: American Indian or Alaska Native women"
    label variable grasiam  "GR: Asian men"
    label variable grasiat  "GR: Asian total"
    label variable grasiaw  "GR: Asian women"
    label variable grbkaam  "GR: Black or African American men"
    label variable grbkaat  "GR: Black or African American total"
    label variable grbkaaw  "GR: Black or African American women"
    label variable grhispm  "GR: Hispanic men"
    label variable grhispt  "GR: Hispanic total"
    label variable grhispw  "GR: Hispanic women"
    label variable grnhpim  "GR: Native Hawaiian or Other Pacific Islander men"
    label variable grnhpit  "GR: Native Hawaiian or Other Pacific Islander total"
    label variable grnhpiw  "GR: Native Hawaiian or Other Pacific Islander women"
    label variable grnralm  "GR: Nonresident alien men"
    label variable grnralt  "GR: Nonresident alien total"
    label variable grnralw  "GR: Nonresident alien women"
    label variable grunknm  "GR: Race/ethnicity unknown men"
    label variable grunknt  "GR: Race/ethnicity unknown total"
    label variable grunknw  "GR: Race/ethnicity unknown women"
    label variable grwhitm  "GR: White men"
    label variable grwhitt  "GR: White total"
    label variable grwhitw  "GR: White women"
    
    save "${build_data}/gr.dta", replace
   
