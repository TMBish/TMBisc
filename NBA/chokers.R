library(nbastatR)
library(tidyverse)
library(highcharter)

games2020 = game_logs(2020)

# Initial Pull
#game_inplay_probs = win_probability(games2020$idGame)
#write_rds(game_inplay_probs, "nba-inplay-2020.rds")

# Subsequent Load
game_inplay_probs = read_rds("nba-inplay-2020.rds") 


game_inplay_probs = game_inplay_probs %>% filter(!is.na(timeRemaining)) %>% distinct()

# Example Game
game = game_inplay_probs %>% filter(idGame == sample(idGame, 1))


qtr4_sum = 
  game_inplay_probs %>%
  filter(numberPeriod >= 3) %>%
  group_by(dateGame, idGame, team = slugTeamHome) %>%
  summarise(
    max_win = max(pctWinProbHome)
  ) %>%
  ungroup() %>%
  bind_rows(
    game_inplay_probs %>%
      filter(numberPeriod >= 3) %>%
      group_by(dateGame, idGame, team = slugTeamAway) %>%
      summarise(
        max_win = max(pctWinProbAway)
      ) %>%
      ungroup()
  )

game_winners = 
  game_inplay_probs %>%
  group_by(idGame, slugTeamHome, slugTeamAway) %>%
  arrange(desc(numberEvent)) %>%
  slice(1) %>%
  mutate(
    winner = ifelse(ptsTotalHome > ptsTotalVisitor, slugTeamHome, slugTeamAway)
  ) %>%
  ungroup() %>%
  distinct(idGame, winner)


qtr4_sum %>%
  inner_join(game_winners) %>%
  mutate(lose = ifelse(team != winner, 1, 0)) %>%
  filter(max_win > 0.75, lose == 1) %>%
  group_by(winner) %>%
  summarise(
    chokes = n()
  ) %>%
  arrange(desc(chokes)) %>%
  hchart("column", hcaes(x = winner, y = chokes)) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_yAxis(title = list(text = "Number Of Chokes")) %>%
  hc_title(text = "2019-20 Chokes") %>%
  hc_subtitle(text = "Greater than 75% win prob in the 4th quarter, Lose Game")