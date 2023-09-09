********************************************************************************
* Authors:          Jim Shen
* Task:             Build financial aid
* Data Used:        IPEDS SFA
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
 
    local years    1617 1718 1819 1920 2021
	
* ****************************************************************
* 1. Opening & appending files
* ****************************************************************

	foreach year in `years' {
        quietly: do "$ipeds_do/sfa`year'"
		gen year=`year'
		tempfile sfa`year'
		save `sfa`year''
	}
	
	clear
	foreach year in `years' { 
		append using `sfa`year''
	}
     
* ****************************************************************
* 2. Generate year
* ****************************************************************
 
    tostring year, replace
    replace year="20"+substr(year,3,4)
    destring year, replace

* ****************************************************************
* 3. Keep Variables of interest
* ****************************************************************

    keep unitid year scugrad scugffn ///
    scfa2 scfa11n scfa11p scfa12n scfa12p scfa13n scfa13p ///
    scfy2 scfy11n scfy11p scfy12n scfy12p scfy13n scfy13p ///    
    uagrntn uagrntp uagrntt uagrnta ///
    fgrnt_n fgrnt_p fgrnt_t fgrnt_a ///
    sgrnt_n sgrnt_p sgrnt_t sgrnt_a ///
    igrnt_n igrnt_p igrnt_t igrnt_a ///
    npist2 npis412 npis422 npis432 npis442 npis452 ///
    npgrn2 npt412 npt422 npt432 npt442 npt452 ///
    grn4a2 grn4a12 grn4a22 grn4a32 grn4a42 grn4a52 ///
    gis4a2 gis4a12 gis4a22 gis4a32 gis4a42 gis4a52
    
* ****************************************************************
* 4. Combine the net price and average aid variables for private
*    and public institutions
* ****************************************************************  
    
    local pricevar 412 422 432 442 452
    local avgaidvar 4a2 4a12 4a22 4a32 4a42 4a52
    local tuitionvar 2 11n 11p 12n 12p 13n 13p
    
    foreach var in `tuitionvar' {
        replace scfa`var' = scfy`var' if scfa`var'==.
    }
    foreach var in `pricevar' {
        replace npis`var' = npt`var' if npis`var'==.
    }
    foreach var in `avgaidvar' {
        replace gis`var' = grn`var' if gis`var'==.
    }
    replace npist2=npgrn2 if npist2==.   
    
    drop grn* npt* npgrn* scfy*
    
* ****************************************************************
* 5. Update variable labels, clean data so there are no negative
*    costs of attendance
* ****************************************************************  
    
    label var scugrad "Total Undergraduates"
    label var scugffn "Total FTFT Undergraduates"
    label var scfa2   "Number of undergradutes in fall cohort"
    label var scfa11n "Number of in-distrct students"
    label var scfa11p "Percentage of in-district students"
    label var scfa12n "Number of in-state students"
    label var scfa12p "Percentage of in-state students"
    label var scfa13n "Number of out-of-state students"
    label var scfa13p "Percentage of out-of-state students"
    label var uagrntn "Number of students awarded grant aid"
    label var uagrntp "Percentage of students awarded grant aid"
    label var uagrntt "Total amount of grant aid awarded"
    label var uagrnta "Average amount of grant aid awarded"
    label var fgrnt_n "Number of students awarded federal grants"
    label var fgrnt_p "Percentage of students awarded federal grants"
    label var fgrnt_t "Total amount of federal grants awarded"
    label var fgrnt_a "Average amount of federal grants aid"
    label var sgrnt_n "Number of students awarded state/local grants"
    label var sgrnt_p "Percentage of students awarded state/local grants"
    label var sgrnt_t "Total amount of state/local grants awarded"
    label var sgrnt_a "Average amount of state/local grants aid"
    label var igrnt_n "Number of students awarded institutional grants"
    label var igrnt_p "Percentage of students awarded institutional grants"
    label var igrnt_t "Total amount of institutional grants awarded"
    label var igrnt_a "Average amount of institutional grant aid"
    label var gis4a2  "Average amount of aid"
    label var gis4a12 "Average amount of aid, income $0-$30k"
    label var gis4a22 "Average amount of aid, income $30k-$48k"
    label var gis4a32 "Average amount of aid, income $48k-$75k"
    label var gis4a42 "Average amount of aid, income $75k-$110k"
    label var gis4a52 "Average amount of aid, income >$110k"
    label var npist2  "Average net price"
    label var npis412 "Average net price, income $0-$30k"
    label var npis422 "Average net price, income $30k-$48k"
    label var npis432 "Average net price, income $48k-$75k"
    label var npis442 "Average net price, income $75k-$110k"
    label var npis452 "Average net price, income >$110k"

    foreach var of varlist npis* {
        replace `var'=`var'*(-1) if `var'<0
    }
    
    save "${build_data}/sfa.dta", replace