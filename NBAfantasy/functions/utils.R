source_dir = function(.dir) {

    files = 
        list.files(.dir, full.names = TRUE, pattern = "\\.(r|R)$")
    
    x = files %>% map(source)

    files %>%
        str_c(collapse = "\n") %>%
        cat()

}