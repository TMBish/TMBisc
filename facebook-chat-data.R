library(tidyverse)
library(jsonlite)
library(anytime)
library(lubridate)

# Hoops Only Chat Data
# ____________________

json = jsonlite::read_json("data/hoops-only-log.json")


# Data Frame
# ____________________

df = 
  json %>% 
  pluck("messages") %>% 
  enframe() %>% 
  mutate(
    sender = value %>% map_chr("sender_name"),
    content = value %>% map_chr(.f = function(x){if(is.null(x$content)) return(NA); x$content}),
    timestamp = value %>% map_chr("timestamp_ms"),
    type = value %>% map_chr("type")
  ) %>%
  select(-name, -value) %>%
  mutate(
    datetime = 
      timestamp %>% 
      str_remove("\\.0+") %>%
      str_remove("\\d{3}$") %>%
      as.numeric() %>%
      anytime(),
    date = as_date(datetime)
  )


df %>% 
  select(-timestamp) %>%
  write_csv("hoops-only-logs.csv")

# Graphs
# ____________________

df %>%
  group_by(sender) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = sender, y = messages), color = "#FF331F") %>%
  hc_title(text = "Total Messages By Person") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE)))


df %>%
  group_by(date, sender) %>%
  summarise(messages = n()) %>%
  ungroup() %>%
  group_by(sender) %>%
  mutate(cumulative_posts = cumsum(messages)) %>%
  hchart("line", hcaes(x = date, y = cumulative_posts, group = sender)) %>%
  hc_title(text = "Cumulative Messages") %>%
  hc_add_theme(hc_theme_elementary())


df %>%
  group_by(date) %>%
  summarise(messages = n()) %>%
  arrange(desc(messages)) %>%
  head(20) %>%
  mutate(date = as.character(date)) %>%
  hchart("column", hcaes(x = date, y = messages), color = "#FF331F") %>%
  hc_title(text = "20 highest message days")


# Teams Based Logic
# ____________________

team_list = 
  nbastatR::nba_teams() %>%
  filter(isNonNBATeam == 0) %>%
  select(nameTeam, teamName, cityTeam, teamNameFull) %>%
  mutate_all(str_to_lower) %>%
  filter(cityTeam != "la")


# This takes ages \
team_match = 
  df %>%
  regex_left_join(team_list, by = c("content" = "teamName")) %>%
  regex_left_join(team_list, by = c("content" = "cityTeam"))

team_match %>%
  mutate(
    team = nameTeam.x %>% coalesce(nameTeam.y)
  ) %>%
  select(content, team, sender) %>%
  filter(!is.na(team)) %>%
  filter(!(sender %in% c("James James"))) %>%
  group_by(team, sender) %>%
  summarise(
    messages = n()
  ) %>%
  group_by(team) %>%
  mutate(total_messages = sum(messages)) %>%
  ungroup() %>% 
  arrange(desc(total_messages, messages)) %>%
  hchart("column", hcaes(x = team, y = messages, group = sender)) %>%
  hc_plotOptions(column = list(stacking = "normal")) %>%
  hc_add_theme(hc_theme_flat()) %>%
  hc_title(text = "Total Messages By NBA Team") %>%
  hc_subtitle(text = 'Split by message sender')
  
  
  
team_match %>%
  filter(sender == "Calham James") %>%
  filter(!is.na(teamName)) %>%
  group_by(teamName) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = teamName, y = messages), color = "#FF331F") %>%
  hc_title(text = "Who Does Cal Talk About?")

team_match %>%
  filter(sender == "Max Massingham") %>%
  filter(!is.na(teamName)) %>%
  group_by(teamName) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = teamName, y = messages), color = "#FF331F") %>%
  hc_title(text = "Who Does Max Talk About?")

  
team_match %>%
  filter(sender == "Tom Bishop") %>%
  filter(!is.na(teamName)) %>%
  group_by(teamName) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = teamName, y = messages), color = "#FF331F") %>%
  hc_title(text = "Who Does Tom Talk About?")

team_match %>%
  filter(sender == "Christian Burgin") %>%
  filter(!is.na(teamName)) %>%
  group_by(teamName) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = teamName, y = messages), color = "#FF331F") %>%
  hc_title(text = "Who Does Crit Talk About?")

  