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

    local years1    2018 2019 2020 2021
    local years2    1718 1819 1920 2021
    
    local files1    hd effy gr adm
    local files2    sfa
    local files3    ef
    local suffix3   a b
    
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
 
    foreach year in `years1' {
        foreach file in `files3' {
            foreach suffix in `suffix3' {
                cd "${raw}"
                if fileexists("`file'`year'`suffix'.csv") == 0 {
                    copy "$nces_src/`file'`year'`suffix'.zip" ///
                    "`file'`year'`suffix'.zip"
                   
                    unzipfile `file'`year'`suffix'.zip
                    erase `file'`year'`suffix'.zip
                }
                if fileexists("`file'`year'`suffix'_rv.csv") == 1 {
                    erase `file'`year'`suffix'.csv
                    !rename "`file'`year'`suffix'_rv.csv" "`file'`year'`suffix'.csv"
                }
            
                cd "${doc}"
                if fileexists("`file'`year'`suffix'.xlsx") == 0 {
                    copy "$nces_src/`file'`year'`suffix'_dict.zip" ///
                    "`file'`year'`suffix'_dict.zip"
                    
                   unzipfile "`file'`year'`suffix'_dict.zip" 
                   erase "`file'`year'`suffix'_dict.zip"
                }

                cd "${ipeds_do}"
                if fileexists("`file'`year'`suffix'.do") == 0 {
                    copy "$nces_src/`file'`year'`suffix'_stata.zip" ///
                    "`file'`year'`suffix'_stata.zip"
                    
                   unzipfile "`file'`year'`suffix'_stata.zip" 
                   erase "`file'`year'`suffix'_stata.zip"
                python script dict_path_fix.py, args(`file'`year'`suffix' "$raw_code")                
                }
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