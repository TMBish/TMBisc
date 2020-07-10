library(tidyverse)
library(httr)
library(glue)
library(rvest)

# Load functions
source("functions/utils.R")
source_dir("functions/yahoo/")


# Get Yahoo Data
# ______________________

# yahoo_login(
#   league_id = '17932',
#   username = 'tomwbish@gmail.com'
# )
# 
# 
# yahoo_player_url = "https://basketball.fantasysports.yahoo.com/nba/17932/players?status=A&pos=P&cut_type=33&stat1=S_AS_2018&myteam=0&sort=OR&sdir=1&count={sequences}"
# 

# Get Yahoo Fantasy Data
# ______________________

# yahoo_get_player_page = function(.url) {
#   
#   .url %>%
#     read_html() %>%
#     html_node(xpath = "//table[contains(@class, 'Table')]")
#   
#   
# }
# sequences = seq(0,450, by = 25)
#   
# glue("https://basketball.fantasysports.yahoo.com/nba/17932/players?status=A&pos=P&cut_type=33&stat1=S_AS_2018&myteam=0&sort=OR&sdir=1&count={sequences}") %>%
#   

# Cntrl C + Cntrl V Job
# ______________________

nasty = read_csv("data/yahoo-data.csv", col_types = list(MPG = col_character()))

df = nasty %>% clean_nasty_yahoo()