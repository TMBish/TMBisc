library(tidyverse)
library(yaml)

# taml tidyer
tidy_film_yaml = function(yaml) {
  
  yaml %>%
  enframe() %>%
    filter(name == "reviews") %>%
    select(-name) %>%
    unnest_longer(value) %>%
    unnest_wider(value) %>%
    unnest_wider(ratings) %>%
    unnest_wider(overall) %>%
    unnest_wider(components) %>%
    janitor::clean_names() %>%
    mutate(edition = yaml$edition) %>%
    select(edition, everything())
  
}

# Read and tidy film review / rating yaml
film_df = 
  list.files("D:/github/tmbish_me/content/films/yaml/", full.names = TRUE) %>%
  map_dfr(~{
    yaml.load_file(.) %>%
      tidy_film_yaml() %>%
      mutate(title = unlist(title))
  })

# Write to google drive
film_df %>%
  write_csv("D:\\googledrive\\Tom and Hannah\\Movies\\reviews.csv")



