taskscheduler_find_wd = function(parent_dir = NULL) {
        
    filePath = 
        stringr::str_replace(stringr::str_subset(commandArgs(trailingOnly = FALSE), "\\--file="), "\\--file=", "") 
        
    if (is.null(parent_dir)) {
        dir = dirname(filePath)
    } else {
        dir = stringr::str_extract(filePath, stringr::str_c(".+", parent_dir))
    }
        
    if (length(dir)>0) {
        setwd(dir)
    }

}