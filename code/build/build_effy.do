********************************************************************************
* Authors:          Jim Shen
* Task:             Build enrollment (race/gender)
* Data Used:        IPEDS EFFY
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
        quietly: do "$ipeds_do/effy`year'"
		gen year=`year'
		tempfile effy`year'
		save `effy`year''
	}

	clear
	forvalues year = `year_min'(1)`year_max' { 
		append using `effy`year''
	}

* ****************************************************************
* 2. Keep variables and sample of interest
* ****************************************************************

    keep if effylev=="Undergraduate":label_effylev
    
    drop effyalev effylev lstudy x*
   
* ****************************************************************
* 3. Relabel variables
* ****************************************************************

    label variable efy2morm "Enrollment: Two or more races men"
    label variable efy2mort "Enrollment: Two or more races total"
    label variable efy2morw "Enrollment: Two or more races women"
    label variable efyaianm "Enrollment: American Indian or Alaska Native men"
    label variable efyaiant "Enrollment: American Indian or Alaska Native total"
    label variable efyaianw "Enrollment: American Indian or Alaska Native women"
    label variable efyasiam "Enrollment: Asian men"
    label variable efyasiat "Enrollment: Asian total"
    label variable efyasiaw "Enrollment: Asian women"
    label variable efybkaam "Enrollment: Black or African American men"
    label variable efybkaat "Enrollment: Black or African American total"
    label variable efybkaaw "Enrollment: Black or African American women"
    label variable efyhispm "Enrollment: Hispanic or Latino men"
    label variable efyhispt "Enrollment: Hispanic or Latino total"
    label variable efyhispw "Enrollment: Hispanic or Latino women"
    label variable efynhpim "Enrollment: Native Hawaiian or Other Pacific Islander men"
    label variable efynhpit "Enrollment: Native Hawaiian or Other Pacific Islander total"
    label variable efynhpiw "Enrollment: Native Hawaiian or Other Pacific Islander women"
    label variable efynralm "Enrollment: Nonresident alien men"
    label variable efynralt "Enrollment: Nonresident alien total"
    label variable efynralw "Enrollment: Nonresident alien women"
    label variable efytotlm "Enrollment: Grand total men"
    label variable efytotlt "Enrollment: Grand total"
    label variable efytotlw "Enrollment: Grand total women"
    label variable efyunknm "Enrollment: Race/ethnicity unknown men"
    label variable efyunknt "Enrollment: Race/ethnicity unknown total"
    label variable efyunknw "Enrollment: Race/ethnicity unknown women"
    label variable efywhitm "Enrollment: White men"
    label variable efywhitt "Enrollment: White total"
    label variable efywhitw "Enrollment: White women"

    
    save "${build_data}/effy.dta", replace