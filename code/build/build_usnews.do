********************************************************************************
* Authors:          Jim Shen
* Task:             Build US News data
* Data Used:        IPEDS HD
* Created:          2023-09-06
* Modified:         2023-09-06
********************************************************************************
* Import and merge the US News data from the following source: Andrew G. Reiter,
* "U.S. News & World Report Historical Liberal Arts College and University 
* Rankings," available at: http://andyreiter.com/datasets/
*
* Keep only the years we are interested in, top 100 schools on each list
********************************************************************************
    clear
    
* Local variables

	local year_min = 2017
	local year_max = 2021

* ****************************************************************   
* LAC file 
* ****************************************************************   

    import excel "${raw}/usnews_lac.xlsx", sheet("Rankings") ///
    cellrange(A2:AO363) firstrow clear
     
    rename IPEDSID unitid
    rename F ranklac2021
    rename G ranklac2020
    rename H ranklac2019
    rename I ranklac2018
    rename J ranklac2017
    
    keep unitid rank*
    
    destring rank*, force replace
    
    collapse (firstnm) ranklac*, by(unitid)
    
    reshape long ranklac,  i(unitid) j(year)
    
    drop if ranklac>100
       
    tempfile ranklac
    save `ranklac'

* ****************************************************************   
* Uni file 
* ****************************************************************   
    
    import excel "${raw}/usnews_uni.xlsx", sheet("Rankings") ///
    cellrange(A2:AO169) firstrow clear
    
    rename IPEDSID unitid
    rename F rankuni2021
    rename G rankuni2020
    rename H rankuni2019
    rename I rankuni2018
    rename J rankuni2017
    
    keep unitid rank*
    
    reshape long rankuni,  i(unitid) j(year)
    
    drop if rankuni>100
      
* ****************************************************************   
* Merge and label
* ****************************************************************    
    
    merge 1:1 unitid year using `ranklac'  
    
    drop _merge
    
    forvalues j = `year_min'(1)`year_max' {
		local y1 = `j'-1
        local y2 = `j'-2000
		label define year `j' "`y1'-`y2'", modify add
	}
    
    label values year year
    
    gen top100lac=1 if ranklac!=.
    gen top100uni=1 if rankuni!=.
    
    label var year       "Academic Year"
    label var rankuni    "US News & World Report Rank (Universities)"
    label var ranklac    "US News & World Report Rank (Liberal Arts Colleges)"
    label var top100lac  "Top 100 US News & World Report Liberal Arts Colleges"
    label var top100uni  "Top 100 US News & World Report Universities"
    
    save "${build_data}/usnews.dta", replace

    