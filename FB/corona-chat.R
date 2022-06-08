library(tidyverse)
library(jsonlite)
library(anytime)
library(lubridate)
library(highcharter)
library(COVID19)

# Some Extra Stuff
# ______________

# Highcharts Theme
source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# COVID Case Data
# ____________________

covid = COVID19::covid19(country = "AUS", verbose = FALSE) %>% as_tibble()     

# Chat Data
# ____________________

thread_json = jsonlite::read_json("data/covid-thread.json")

thread_df = 
  json %>% 
  pluck(., "messages") %>%
  enframe() %>% 
  mutate(
    sender = value %>% map_chr("sender_name"),
    content = value %>% map_chr(.f = function(x) {if(is.null(x$content)) return(NA); x$content}),
    reactions = value %>% map_dbl(.f = function(x){if(is.null(x$reactions)) return(NA); length(x$reactions)}),
    reactors = value %>% map(.f = function(x){if(is.null(x$reactions)) return(NULL); tibble(reactor = x$reactions %>% map_chr("actor"))}),
    is_photo = value %>% map_lgl(.f = function(x){if(is.null(x$photo)) return(FALSE); TRUE}),
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

# Covd vs Chat
# ____________________

cases_vs_messages =
  covid %>%
  select(date, cCases = confirmed) %>%
  mutate(cases = cCases - lag(cCases,1) %>% coalesce(cCases)) %>%
  left_join(
    thread_df %>%
      group_by(date) %>%
      summarise(
        messages = n(), .groups = "drop"
      )
  ) %>%
  mutate(
    messages = messages %>% coalesce(0),
    cMessages = cumsum(messages)
  )

hchart(cases_vs_messages, "area", hcaes(x = date, y = messages), name = "'Coronavirus Only' Posts", showInLegend = TRUE) %>%
  hc_yAxis_multiples(
    list(title = list(text = "Corona Virus Only")),                    
    list(title = list(text = "Australian Covid Cases"), opposite = TRUE) 
  ) %>%
  hc_add_series(cases_vs_messages, "area",hcaes(x = date, y = cases),  name = "Covid Cases", yAxis = 1, showInLegend = TRUE) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_title(text = "Covid vs Covid Chat") %>%
  hc_legend(enabled = TRUE, verticalAlign = "bottom", align = "center")



covid_vs_cases_months =
  covid %>%
  select(date, cCases = confirmed) %>%
  mutate(cases = cCases - lag(cCases,1) %>% coalesce(cCases)) %>%
  group_by(month = floor_date(date, unit = "month")) %>%
  summarise(across(cases, sum)) %>%
  left_join(
    thread_df %>%
      group_by(month = floor_date(date, unit = "month")) %>%
      summarise(
        messages = n(), .groups = "drop"
      )
  ) %>%
  mutate(
    messages = messages %>% coalesce(0)
  )

hchart(covid_vs_cases_months, "scatter", hcaes(y = cases, x = messages)) %>%
  hc_add_theme(hc_theme_tmbish())

# Misc Graphs
# ____________________

df %>%
  group_by(sender) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = sender, y = messages)) %>%
  hc_title(text = "Total Messages By Person") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_tmbish())

df %>%
  group_by(datetime) %>%
  summarise(messages = n()) %>%
  ungroup() %>%
  mutate(
    cumulative_posts = cumsum(messages),
    datetime = highcharter::datetime_to_timestamp(datetime)
  ) %>%
  hchart("line", hcaes(x = datetime, y = cumulative_posts)) %>%
  hc_title(text = "Corona Only") %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Total Posts")) %>%
  hc_xAxis(
    type = 'datetime',
    labels = list(format = '{value: %d-%m}')
  )


df %>%
  group_by(datetime, sender) %>%
  summarise(messages = n()) %>%
  ungroup() %>%
  group_by(sender) %>%
  mutate(
    cumulative_posts = cumsum(messages),
    datetime = highcharter::datetime_to_timestamp(datetime)
  ) %>%
  hchart("line", hcaes(x = datetime, y = cumulative_posts, group = sender)) %>%
  hc_title(text = "Corona Only") %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Total Posts")) %>%
  hc_xAxis(
    type = 'datetime',
    labels = list(format = '{value: %d-%m}')
  )

df %>%
  filter(date >= "2019-09-01") %>%
  group_by(sender) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = sender, y = messages)) %>%
  hc_title(text = "Hoops Only") %>%
  hc_subtitle(text = "2019-20 Season") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Total Messages"))

df %>%
  filter(date >= "2019-09-01", type == "Share") %>%
  group_by(date, sender) %>%
  summarise(messages = n()) %>%
  ungroup() %>%
  group_by(sender) %>%
  mutate(cumulative_posts = cumsum(messages)) %>%
  hchart("line", hcaes(x = date, y = cumulative_posts, group = sender)) %>%
  hc_title(text = "Hoops Only") %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Cumulative Shares"))

df %>%
  filter(date >= "2019-09-01") %>%
  unnest(reactors) %>%
  group_by(reactor) %>%
  summarise(
    reactions = n()
  ) %>%
  arrange(desc(reactions)) %>%
  hchart("column", hcaes(x = reactor, y = reactions)) %>%
  hc_title(text = "Hoops Only") %>%
  hc_subtitle(text = "2019-20 Season") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Total Reactions"))

# React Rate
df %>%
  filter(date >= "2019-09-01") %>%
  group_by(sender) %>%
  summarise(
    posts = n(),
    reactions = sum(reactions, na.rm = TRUE)
  ) %>%
  mutate(
    reaction_per_post = round((reactions / posts) * 100)
  ) %>%
  arrange(desc(reaction_per_post)) %>%
  hchart("column", hcaes(x = sender, y = reaction_per_post)) %>%
  hc_title(text = "Hoops Only") %>%
  hc_subtitle(text = "2019-20 Season") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Reactions Per 100 Posts"))



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

  