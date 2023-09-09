********************************************************************************
* Authors:          Jim Shen
* Task:             Main build file
* Do Files Used:    build_hd.do
*                   build_effy.do
*                   build_adm.do
*                   build_sfa.do
*                   build_gr.do
*                   build_usnews.do
* Created:          2023-09-04
* Modified:         2023-09-04
********************************************************************************
*  Main clean file to call individual clean files
********************************************************************************

* Switches

    local hd        0
    local effy      0
    local adm       0
    local sfa       0
    local gr        0
    local usnews    0
    local ic        0
    local icay      0
    
    local files effy adm sfa gr usnews ic icay
    
* Run based on switches

    if `hd' 				do "${build_code}/build_hd.do"
    if `effy' 				do "${build_code}/build_effy.do"
    if `sfa' 				do "${build_code}/build_sfa.do"
    if `gr' 				do "${build_code}/build_gr.do"
    if `adm' 				do "${build_code}/build_adm.do"
    if `ic' 				do "${build_code}/build_ic.do"
    if `icay'				do "${build_code}/build_icay.do"
    if `usnews'  			do "${build_code}/build_usnews.do"    
    
* Merge all do files

    use "${build_data}/hd.dta", clear
    
    foreach file in `files' {
        merge 1:1 unitid year using "${build_data}/`file'.dta"
        drop if _merge==2
        drop _merge  
    }
    
    save "${build_data}/ipeds.dta", replace
    export excel using "${build_data}/ipeds.xlsx", ///
    keepcellfmt firstrow(varlabels) replace
    