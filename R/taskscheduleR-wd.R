taskscheduler_find_wd = function(parent_dir = NULL) {
    
    library(tidyverse)
    
    filePath = 
        commandArgs(trailingOnly = FALSE) %>% 
        str_subset("\\--file=") %>% 
        str_replace("\\--file=", "") 
        
    if (is.null(parent_dir)) {
        dir = filePath %>% dirname()
    } else {
        dir = filePath %>% str_extract(str_c(".+", parent_dir))
    }
        
    setwd(dir)
    library(here)
    
}