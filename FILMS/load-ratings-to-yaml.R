library(tidyverse)
library(yaml)


# Ratings
ratings = 
  read_csv("D:/github/TMBisc/FILMS/ratings-20200815.csv") %>%
  # select(-rewatch_needed) %>%
  mutate(year = as.integer(year))


# DF lister
film_lister = function(title, year, genre, tom, hannah, story, cinematography, acting, entertainment, dialogue) {
  
  list(
    title = title,
    year = year,
    genre = genre,
    image = NULL,
    "pick-of-the-week" = "no",
    reviewer = NULL,
    "review-text" = NULL,
    "similar-film" = NULL,
    ratings = list(
      overall = list(tom = tom, hannah = hannah),
      components = list(
        story = story,
        dialogue = dialogue,
        acting = acting,
        entertainment = entertainment,
        cinematography = cinematography
      )
    )
  )
  
  
}

# Transform To YAML list
rating_list = 
  ratings %>%
  mutate_at(vars(year), as.integer) %>%
  pmap(
    .f = film_lister
  )


rating_list %>% write_yaml("D:/github/TMBisc/FILMS/rating-list.yaml")