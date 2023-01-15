library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)

Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 2)
standings = nbastatR::standings(seasons = 2023)

# Bet Data ----------------------------------------------------------------

bets = tribble(
  ~nameTeam, ~line, ~ou,
  "Memphis Grizzlies", 48.5, "over",
  "Denver Nuggets", 51.5, "over",
  "New Orleans Pelicans", 45.5, "over",
  "Portland Trail Blazers", 39.5, "under"
)

# Record ------------------------------------------------------------------

win_rates = 
  standings %>% 
  mutate(pctSeasonComplete = (wins+losses) / 82) %>%
  select(slugSeason, nameTeam, pctWinTeam, wins, pctSeasonComplete) %>%
  mutate(projectedWins = pctWinTeam * 82) %>%
  mutate(gamesRemaining = (1-pctSeasonComplete) * 82) %>%
  inner_join(bets)

win_rates
  
  
# Cash out value ------------------------------------------------------------------

pbinom(q = 26, size = 42, p = 0.667)


win_rates %>%
  rowwise() %>%
  mutate(
    price = case_when(
      ou == "over" ~ 1/(1-pbinom(q = (line-wins), size = gamesRemaining, prob = pctWinTeam)),
      TRUE ~ 1/(pbinom(q = (line-wins), size = gamesRemaining, prob = pctWinTeam))
    ) %>% round(2)
  ) %>%
  select(nameTeam, projectedWins, line, ou, gamesRemaining, bishLivePrice = price)
  