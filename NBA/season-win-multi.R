library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(future)
library(reactable)

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

# Tracker ------------------------------------------------------------------

win_rates = 
  standings %>% 
  mutate(pctSeasonComplete = (wins+losses) / 82) %>%
  select(slugSeason, nameTeam, pctWinTeam, wins, pctSeasonComplete) %>%
  mutate(projectedWins = pctWinTeam * 82) %>%
  mutate(gamesRemaining = (1-pctSeasonComplete) * 82) %>%
  inner_join(bets)


win_rates %>%
  rowwise() %>%
  mutate(
    price = case_when(
      ou == "over" ~ 1/(1-pbinom(q = (line-wins), size = gamesRemaining, prob = pctWinTeam)),
      TRUE ~ 1/(pbinom(q = (line-wins), size = gamesRemaining, prob = pctWinTeam))
    ) %>% round(2),
    projectedWins = round(projectedWins, 1)
  ) %>%
  select(nameTeam, gamesRemaining, ou, line, projectedWins, estimated_current_odds = price) %>%
  reactable(
    
    compact=TRUE,
    pagination = FALSE,
    borderless = FALSE,
    outlined = TRUE,
    striped = FALSE,
    defaultColDef = colDef(headerClass = "header",  align = "center", footerStyle = list(fontWeight = "bold")),
    columns = list(
      nameTeam = colDef(name = "Team"),
      projectedWins = colDef(name = "Projected Wins", footer = "Multi Odds"),
      line = colDef(name = "Line Bet"),
      ou = colDef(name = "Side"),
      gamesRemaining = colDef(name = "Games Remaining"),
      estimated_current_odds = colDef(name = "Estimated Odds", footer = function(values) sprintf("$%.2f", prod(values)))
    )
  )

  