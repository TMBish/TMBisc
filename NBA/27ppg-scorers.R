library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)

# Getting Data
# ______________

plan(multiprocess) 

df = metrics_leaders(
  seasons = 1985:2020,
  modes = "PerGame"
)

source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# Charts
# ______________

df %>%
  filter(pts >= 27) %>%
  group_by(slugSeason) %>%
  summarise(
    scorers = n()
  ) %>%
  hchart("bar", hcaes(x = slugSeason, y = scorers)) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Players with 27+ ppg average")) %>%
  hc_title(text = "27 Points Per Game")


# Scoring Average Of Top 10 PPG Ranked Players
df %>%
  filter(numberRank <= 20) %>%
  group_by(slugSeason) %>%
  summarise(
    ppg = mean(pts)
  ) %>%
  hchart("line", hcaes(x = slugSeason, y = ppg)) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Players with 27+ ppg average")) %>%
  hc_title(text = "27 Points Per Game")





# APG
# _______________

df = metrics_leaders(
  seasons = 2020,
  metric = "ast",
  modes = "PerGame"
)

df %>%
  filter(numberRank <= 10) %>%
  hchart("bar", hcaes(x = namePlayer, y = ast)) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_title(text = "19-20 Assists")



# Isolating Key Players
# ______________

# Jon Isaac
isaac = 
  gamelogs %>%
  filter(namePlayer == "Jonathan Isaac", typeSeason == "Regular Season") %>% 
  arrange(desc(dateGame)) %>%
  select(slugSeason, slugMatchup, namePlayer, stocks)

# Summarise Postions: Centers vs Non Centers
#   + Centers defined as one or more season with a C or F-C position label according to the rosters dataset
playerPositions = 
  rosters %>%
  mutate(
    isCenter = groupPosition %>% str_detect("C") %>% coalesce(FALSE)
  ) %>%
  group_by(namePlayer) %>%
  summarise(
    isCenter = max(isCenter)
  )

# Isolating Key Players
#   + Players first X games (isaacs games so far)
#   + Non centers
#   + Steals and blocks per 36 minutes
#   + Filter By Top 20 total stocks
bigStockers = 
  gamelogs %>%
  inner_join(
    playerPositions %>% filter(isCenter != 1),
    by = "namePlayer"
  ) %>%
  group_by(namePlayer) %>%
  arrange(dateGame) %>%
  mutate(
    game_number = row_number()
  ) %>%
  ungroup() %>%
  filter(game_number <= nrow(isaac)) %>%
  group_by(namePlayer) %>%
  summarise(
    first_season = min(yearSeason),
    minutes = sum(minutes),
    steals = sum(stl),
    blocks = sum(blk),
    stocks = sum(stocks),
    games = n()
  ) %>%
  filter(first_season >= 2000) %>%
  arrange(desc(stocks)) %>%
  mutate(
    rownumber = row_number()
  ) %>%
  filter(
    rownumber <= 20 | namePlayer == "Matisse Thybulle"
  )



# Cumulative Stocks
# __________________

# Jon Isaac
gamelogs %>%
  inner_join(
    bigStockers %>% select(namePlayer)
  ) %>%
  group_by(namePlayer) %>%
  arrange(dateGame) %>%
  mutate(
    game_number = row_number()
  ) %>%
  ungroup() %>%
  filter(game_number <= nrow(isaac)) %>%
  group_by(namePlayer) %>%
  arrange(dateGame) %>%
  mutate(
    cumulative_stocks = cumsum(stocks),
    cumulative_minutes = cumsum(minutes)
  ) %>%
  select(namePlayer, game_number, stocks, cumulative_stocks, cumulative_minutes) %>%
 # mutate(stocks_per_minute = 36 * (cumulative_stocks / cumulative_minutes)) %>%
  #filter(game_number <= max(filter(., namePlayer == "Jonathan Isaac") %>% pull(game_number))) %>%
  hchart("line", hcaes(x = game_number, y = cumulative_stocks, group = namePlayer)) %>%
  hc_add_theme(high_tmbish())



# Stocks Per36 Minutes
# __________________


stockBase = 
  bigStockers %>%
  mutate(
    steals_per36 = (steals / minutes) * 36,
    blocks_per36 = (blocks / minutes) * 36,
    stocks_per36 = (stocks / minutes) * 36
  ) %>%
  arrange(desc(stocks_per36)) %>%
  mutate(
    color_group = case_when(
      namePlayer == "Jonathan Isaac" ~ "Isaac",
      namePlayer == "Matisse Thybulle" ~ "Thybulle",
      TRUE ~ "Other"
    )
  ) %>%
  mutate(
    nameLabel = case_when(
      namePlayer == "Matisse Thybulle" ~ str_c(namePlayer, "*"),
      TRUE ~ namePlayer
    )
  ) %>%
  mutate_at(
    vars(matches("per36")),
    ~round(.,1)
  )

thybulle = stockBase %>% filter(namePlayer == "Matisse Thybulle")

# Player Pgotos
player_photo = 
  nbastatR::nba_players() %>%
  select(namePlayer, urlPlayerThumbnail)

# Creating The Face Series
photoList = 
  stockBase %>%
  inner_join(player_photo) %>%
  ungroup() %>%
  mutate(
    x = row_number()-1,
    y = stocks_per36 + 0.5
  ) %>%
  select(x = x, y = y, urlPlayerThumbnail) %>%
  pmap(
    function(x, y, urlPlayerThumbnail) {
      list(
        x = x,
        y = y,
        marker = list(symbol = glue("url({urlPlayerThumbnail})"), height = 40, width = 55)
      ) 
    }
  ) %>%
  list(
    name = "Player Photo",
    data = .
  ) %>%
  list()

# Ordered Stocks Column Chart
stockBase %>%
  hchart("column", hcaes(x = nameLabel, y = stocks_per36, color = colorize(color_group, c("#0077C0", "#D3D3D3", "#ED174C")))) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_add_series_list(photoList) %>%
  hc_chart(
    spacingLeft = 20,
    spacingRight = 20
  ) %>%
  hc_yAxis(
    title = list(text = "Stocks Per 36 Minutes", style = list(fontSize = "1.8em")), 
    lineWidth = 0, 
    labels = list(enabled = FALSE),
    max = max(stockBase$stocks_per36) + 0.5
  ) %>%
  hc_xAxis(
    title = list(text = ""),
    labels = list(style = list(fontSize = "1.2em"))
  ) %>%
  hc_title(text = "Big Stockers (Steals + Blocks)", align = "center") %>%
  hc_subtitle(
    text = "All non-centers, drafted since 2000, over their first 131 games (Isaac's games played at 2019-12-29)",
    style = list(fontSize = "1.4em"),
    align = "center"
  ) %>%
  hc_credits(
    text = glue("*Smaller Sample: only {thybulle$games} games & {thybulle$minutes} minutes"), 
    enabled = TRUE,
    style = list(fontSize = "1.1em")
  ) %>%
  hc_plotOptions(
    column = list(dataLabels = list(enabled = TRUE)),
    line = list(lineWidth = 0)
  )









