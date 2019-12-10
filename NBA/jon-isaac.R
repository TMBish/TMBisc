library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)

# Getting Data
# ______________

plan(multiprocess) 

gamelogs = nbastatR::game_logs(1990:2020)

# Isolating Key Players
# ______________

gamelogs %>% colnames()

# Add Stocks
gamelogs =
  gamelogs %>% 
  mutate(
    stocks = blk + stl
  )

# High Stock Careers
bigStockers = 
  gamelogs %>%
  group_by(namePlayer) %>%
  summarise(
    first_season = min(yearSeason),
    stocks_total = sum(stocks),
    stocks_avg = mean(stocks),
    games = n()
  ) %>%
  filter(games > 100, first_season >= 2003) %>%
  arrange(desc(stocks_avg)) %>%
  head(10)

# Jon Isaac
gamelogs %>%
  filter(namePlayer == "Jonathan Isaac" | namePlayer %in% bigStockers$namePlayer) %>%
  group_by(namePlayer) %>%
  arrange(dateGame) %>%
  mutate(
    game_number = row_number()
  ) %>%
  mutate(
    cumulative_stocks = cumsum(stocks),
    cumulative_minutes = cumsum(minutes)
  ) %>%
  select(namePlayer, game_number, stocks, cumulative_stocks, cumulative_minutes) %>%
  mutate(stocks_per_minute = 36 * (cumulative_stocks / cumulative_minutes)) %>%
  #filter(game_number <= max(filter(., namePlayer == "Jonathan Isaac") %>% pull(game_number))) %>%
  hchart("line", hcaes(x = game_number, y = stocks_per_minute, group = namePlayer))





