clean_nasty_yahoo = function(.df) {
  
  
  .df %>%
    select(-X1, -X3, -Owner, -contains("Opp"), -contains("Pre-Season"), -contains("% Owned")) %>%
    mutate(
      player = case_when(
       Players %>% str_detect("Note") ~ lead(Players,1) %>% str_extract("[A-Z]{1}\\. [A-Za-z]+"),
       TRUE ~ Players %>% str_extract("[A-Z]{1}\\. [A-Za-z]+")
      ),
      position = case_when(
        Players %>% str_detect("Note") ~ lead(Players,1) %>% str_extract("(?<=\\- )[A-Z\\,]+"),
        TRUE ~ Players %>% str_extract("(?<=\\- )[A-Z\\,]+")
      )
    ) %>%
    janitor::clean_names() %>%
    filter(!is.na(gp)) %>%
    mutate(mpg = mpg %>% str_remove("\\:\\d{2}$") %>% str_replace(":", ".") %>% as.numeric()) %>%
    mutate(
      fgm = fgm_a %>% str_extract("[\\d\\.]+(?=\\/)") %>% as.numeric(),
      fga = fgm_a %>% str_extract("(?<=\\/)[\\d\\.]+") %>% as.numeric(),
      ftm = ftm_a %>% str_extract("[\\d\\.]+(?=\\/)") %>% as.numeric(),
      fta = ftm_a %>% str_extract("(?<=\\/)[\\d\\.]+") %>% as.numeric()
    ) %>%
    select(player, position, gp, current, mpg, matches("^(fg|ft).+"), everything()) %>%
    select(-players, -fgm_a, -ftm_a)
    
}