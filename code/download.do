********************************************************************************
* Authors:          Jim Shen
* Task:             Download IPEDS data
* Do Files Used:    n/a
* Created:          2023-09-04
* Modified:         2023-09-04
********************************************************************************
*  Download IPEDS data, only use revised data, revise paths for IPEDS provided
*  Stata dictionary do files, move original code files to raw folder
********************************************************************************
    
* List of IPEDS data to retrieve.
* Need multiple lists for inconsistent IPEDS naming conventions

    local years1    2017 2018 2019 2020 2021
    local years2    1617 1718 1819 1920 2021
    
    local files1    hd effy gr adm ic
    local files2    sfa
    local files3    ic
    local suffix3   ay
    
* Retreive IPEDS data, only use revised files, update paths, move 

   foreach year in `years1' {
        foreach file in `files1' {
            cd "${raw}"
            if fileexists("`file'`year'.csv") == 0 {
                copy "$nces_src/`file'`year'.zip" ///
                "`file'`year'.zip"
               
                unzipfile `file'`year'.zip
                erase `file'`year'.zip
            }
            if fileexists("`file'`year'_rv.csv") == 1 {
                erase `file'`year'.csv
                !rename "`file'`year'_rv.csv" "`file'`year'.csv"
            }
            
            cd "${doc}"
            if fileexists("`file'`year'.xlsx") == 0 {
                copy "$nces_src/`file'`year'_dict.zip" ///
                "`file'`year'_dict.zip"
                
               unzipfile "`file'`year'_dict.zip" 
               erase "`file'`year'_dict.zip"
            }
            
            cd "${ipeds_do}"
            if fileexists("`file'`year'.do") == 0 {
                copy "$nces_src/`file'`year'_stata.zip" ///
                "`file'`year'_stata.zip"
                
               unzipfile "`file'`year'_stata.zip" 
               erase "`file'`year'_stata.zip"
               python script dict_path_fix.py, args(`file'`year' "$raw_code")
            }
        }
    }
    
    foreach year in `years2' {
        foreach file in `files2' {
            cd "${raw}"
            if fileexists("`file'`year'.csv") == 0 {
                copy "$nces_src/`file'`year'.zip" ///
                "`file'`year'.zip"
               
                unzipfile `file'`year'.zip
                erase `file'`year'.zip
            }
            if fileexists("`file'`year'_rv.csv") == 1 {
                erase `file'`year'.csv
                !rename "`file'`year'_rv.csv" "`file'`year'.csv"
            }
            
            cd "${doc}"
            if fileexists("`file'`year'.xlsx") == 0 {
                copy "$nces_src/`file'`year'_dict.zip" ///
               "`file'`year'_dict.zip"
                
               unzipfile "`file'`year'_dict.zip" 
               erase "`file'`year'_dict.zip"
            }
            cd "${ipeds_do}"
            if fileexists("`file'`year'.do") == 0 {
                copy "$nces_src/`file'`year'_stata.zip" ///
                "`file'`year'_stata.zip"
                
               unzipfile "`file'`year'_stata.zip" 
               erase "`file'`year'_stata.zip"
               python script dict_path_fix.py, args(`file'`year' "$raw_code")
            }
        }
    }
    
    foreach year in `years1' {
        foreach file in `files3' {
            foreach suffix in `suffix3' {
                cd "${raw}"
                if fileexists("`file'`year'_`suffix'.csv") == 0 {
                    copy "$nces_src/`file'`year'_`suffix'.zip" ///
                    "`file'`year'_`suffix'.zip"
                   
                    unzipfile `file'`year'_`suffix'.zip
                    erase `file'`year'_`suffix'.zip
                }
                if fileexists("`file'`year'_`suffix'_rv.csv") == 1 {
                    erase `file'`year'_`suffix'.csv
                    !rename "`file'`year'_`suffix'_rv.csv" "`file'`year'_`suffix'.csv"
                }
            
                cd "${doc}"
                if fileexists("`file'`year'_`suffix'.xlsx") == 0 {
                    copy "$nces_src/`file'`year'_`suffix'_dict.zip" ///
                    "`file'`year'_`suffix'_dict.zip"
                    
                   unzipfile "`file'`year'_`suffix'_dict.zip" 
                   erase "`file'`year'_`suffix'_dict.zip"
                }

                cd "${ipeds_do}"
                if fileexists("`file'`year'_`suffix'.do") == 0 {
                    copy "$nces_src/`file'`year'_`suffix'_stata.zip" ///
                    "`file'`year'_`suffix'_stata.zip"
                    
                   unzipfile "`file'`year'_`suffix'_stata.zip" 
                   erase "`file'`year'_`suffix'_stata.zip"
                python script dict_path_fix.py, args(`file'`year'_`suffix' "$raw_code")                
                }
            }
        }
    }    
    
    cd "${raw}"    
    if fileexists("usnews_lac.xlsx")==0 {
        copy "https://andyreiter.com/wp-content/uploads/2022/09/US-News-Rankings-Liberal-Arts-Colleges-Through-2023.xlsx" ///
        "${raw}/usnews_lac.xlsx"
    }
    if fileexists("usnews_uni.xlsx")==0 {
        copy "https://andyreiter.com/wp-content/uploads/2022/09/US-News-Rankings-Universities-Through-2023.xlsx" ///
        "${raw}/usnews_uni.xlsx" 
    }
 

 