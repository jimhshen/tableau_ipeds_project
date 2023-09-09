********************************************************************************
* Authors:          Jim Shen
* Task:             Build insitutional characteristics
* Data Used:        IPEDS HD
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
    local dummies tribal hbcu    
	
* ****************************************************************
* 1. Opening & appending files
* ****************************************************************

	forvalues year = `year_min'(1)`year_max' {
        quietly: do "$ipeds_do/hd`year'"
		gen year=`year'
		tempfile hd`year'
		save `hd`year''
	}

	clear
	forvalues year = `year_min'(1)`year_max' { 
		append using `hd`year'', force
	}
    
* ****************************************************************
* 2. Keep variables and sample of interest
* ****************************************************************

* Keep only active, undergraduate degree granting, non-profit 2 and 4 year, open to the public

    keep if (control=="Public":label_control | ///
            control=="Private not-for-profit":label_control) & ///
            (deggrant=="Degree-granting":label_deggrant) & ///
            (iclevel=="Four or more years":label_iclevel | ///
            iclevel=="At least 2 but less than 4 years":label_iclevel) & ///
            openpubl=="Institution is open to the public":label_openpubl & ///
            cyactive=="Yes":label_cyactive & ///
            ugoffer!="No undergraduate offering":label_ugoffer & ///
            instsize!="Not applicable":label_instsize
 
* Keep variables of interest
	keep unitid instnm city stabbr zip year obereg control iclevel instsize ///
    longitud latitude webaddr hbcu tribal
    
* Use 5 digit zip
    replace zip=substr(zip,1,5)
    
* ****************************************************************
* 3. Update variable labels
* ****************************************************************
    
    label var unitid    "IPEDS Number"
    label var year      "Academic Year"    
    label var instnm    "Institution Name"
    label var city      "City"
    label var stabbr    "State"
    label var obereg    "Region"
    label var iclevel   "Two- or four- year college"
    label var control   "Public or private college"
    label var instsize  "Institution size"
    
    label define label_region 0 "U.S. Service schools"
    label define label_region 1 "New England",add
    label define label_region 2 "Mid East",add
    label define label_region 3 "Great Lakes",add
    label define label_region 4 "Plains",add
    label define label_region 5 "Southeast",add
    label define label_region 6 "Southwest",add
    label define label_region 7 "Rocky Mountains",add
    label define label_region 8 "Far West",add
    label define label_region 9 "Other U.S. jurisdictions",add
    label values obereg label_region
    
    label define label_iclevel2 1 "4-year college"
    label define label_iclevel2 2 "2-year college",add
    label values iclevel label_iclevel2
    
    label define label_control2 1 "Public"
    label define label_control2 2 "Private",add
    label values control label_control2
    
    label values `dummies' remove
    
    foreach var in `dummies' {
        replace `var'=0 if `var'==2
    }
    
    save "${build_data}/hd.dta", replace
