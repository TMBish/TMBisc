library(fitzRoy)
library(tidyverse)
library(lubridate)
library(highcharter)


# BL Base Data
# ______________________

player = fitzRoy::get_afltables_stats()

bl = 
  player %>%
  filter(Date > as_date("1978-01-01")) %>%
  mutate(
    name = str_c(First.name, " ",Surname),
    home_win = ifelse(Home.score > Away.score, 1, 0)
  ) %>%
  select(Season, Round, Date,  ID, name, bl = Brownlow.Votes, home = Home.team, away = Away.team, home_win, playing_for = Playing.for) %>%
  mutate(player_win = case_when(
    playing_for == home ~ home_win,
    TRUE ~ ifelse(home_win == 1, 0, 1)
  ))

# BL Per Game vs Win Pct
# ______________________

# BL Summary
bl_per_game = 
  bl %>%
  filter(!(Round %in% c("EF", "PF", "GF", "SF", "QF"))) %>%
  group_by(name, ID) %>%
  summarise(
    total_bl_votes = sum(bl),
    games = n(),
    win_pct = mean(player_win)
  ) %>%
  filter(games >= 23) %>%
  mutate(
    bl_per_game = total_bl_votes / games
  ) %>%
  arrange(desc(bl_per_game)) %>%
  head(25) %>%
  mutate(isFyfe = ifelse(name == "Nat Fyfe", "Y", "N")) 

bl_per_game %>%
  hchart("scatter", hcaes(x = win_pct, y = bl_per_game, color = colorize(isFyfe, c("#A5D8FF", "#FF4A1C")))) %>%
  hc_plotOptions(scatter = list(dataLabels = list(enabled = TRUE, formatter = JS("function(){return(this.point.name)}")))) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "BL Votes Per Game vs Team Win Pct") %>%
  hc_subtitle(text = "Players with more than 23 games > 1978 | Top 50 votes / game") %>%
  hc_yAxis(
    title = list(text = "Average BL Votes / Game"),
    plotLines = list(
      list(
        value = 1,
        width = 2,
        color = "#36393B",
        label = list(
          text = "1 vote per game",
          style = list(color = "#36393B", fontWeight = "bold", fontSize = "12px"),
          align = "left"
        )
      )
    )) %>%
  hc_xAxis(title = list(text = "Team Win Pct"), labels=list(formatter=JS("function(){return(Math.round(this.value * 100) + '%')}")))

# BL Per Loss
# ______________________

bl %>%
  mutate(
    name = case_when(
      ID %in% c(1105, 11700, 1122) ~ str_c(name, " - ", playing_for),
      TRUE ~ name
    )
  ) %>%
  filter(!(Round %in% c("EF", "PF", "GF", "SF", "QF")), player_win == 0) %>%
  group_by(name, ID) %>%
  summarise(
    total_bl_votes = sum(bl),
    total_losses = n()
  ) %>%
  filter(total_losses >= 23) %>%
  mutate(
    bl_per_loss = total_bl_votes / total_losses
  ) %>%
  arrange(desc(bl_per_loss)) %>%
  head(50) %>%
  mutate(isGAJ = ifelse(name == "Gary Ablett - Gold Coast", "Y", "N")) %>%
  hchart("scatter", hcaes(x = total_losses, y = bl_per_loss, color = colorize(isGAJ, c("#A5D8FF", "#FF4A1C")))) %>%
  hc_plotOptions(scatter = list(dataLabels = list(enabled = TRUE, formatter = JS("function(){return(this.point.name)}")))) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "BL Votes Loss vs Total Losses") %>%
  hc_subtitle(text = "Players with more than 23 losses since 1978 | Top 50 votes / loss") %>%
  hc_yAxis(
    title = list(text = "Average BL Votes / Loss")
  ) %>%
  hc_xAxis(title = list(text = "Total Losses"))


# BL as % of Teams BL
# ______________________

df = 
  bl %>%
  mutate(
    name_team = case_when(
      ID %in% c(1105, 11700, 1122) ~ str_c(name, " - ", playing_for),
      TRUE ~ name
    )
  ) %>%
  filter(!(Round %in% c("EF", "PF", "GF", "SF", "QF"))) %>%
  # Team BL Votes
  group_by(Season, Round, playing_for) %>%
  mutate(team_votes = sum(bl)) %>%
  ungroup() %>%
  group_by(name_team, ID) %>%
  summarise(
    bl_votes = sum(bl),
    team_votes = sum(team_votes),
    games = n()
  ) %>%
  filter(games >= 23) %>%
  mutate(
    bl_team_pct = bl_votes / team_votes
  ) %>%
  arrange(desc(bl_team_pct)) %>%
  head(25)

df %>%
  hchart("column", hcaes(x = name_team, y = bl_team_pct)) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "Player Votes as % of Total Team Votes") %>%
  hc_subtitle(text = "Players with more than 23 games since 1978 | Top 50 votes / team votes") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE, formatter=JS("function(){return(Math.round(this.y * 100) + '%')}")))) %>%
  hc_yAxis(title = "Votes / Total Team Votes", labels = list(formatter=JS("function(){return(Math.round(this.value * 100) + '%')}")))
  
  
df %>%
  hchart("scatter", hcaes(x = team_votes, y = bl_votes)) %>%
  hc_plotOptions(scatter = list(dataLabels = list(enabled = TRUE, formatter = JS("function(){return(this.point.name_team)}")))) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "Player Votes vs Team Votes") %>%
  hc_subtitle(text = "Players with more than 23 losses since 1978 | Top 50 votes / team votes") %>%
  hc_yAxis(
    title = list(text = "Individual Votes")
  ) %>%
  hc_xAxis(title = list(text = "Team Votes"))

# Cumulative brownlow votes
# ______________________

key_players = 
  tibble(
    ID = c(1105, 11700, 112, 11834, 11794, 1122, 12595)
  )

bl %>% 
  group_by(ID, name) %>%
  arrange(Date) %>%
  mutate(game_number = row_number()) %>%
  ungroup() %>%
  group_by(ID, name, game_number) %>%
  summarise(bl = sum(bl)) %>%
  group_by(ID, name) %>%
  mutate(
    total_bl = sum(bl),
    cumbl = cumsum(bl)
  ) %>%
  ungroup() %>%
  inner_join(key_players) %>%
  hchart("line", hcaes(x = game_number, y = cumbl, group = name)) %>%
  hc_add_theme(hc_theme_elementary())
  


# Top average votes per game
bl %>%
  group_by(name) %>%
  summarise(
    average_bl_votes = mean(bl, na.rm = TRUE)
  ) %>%
  arrange(desc(average_bl_votes)) %>%
  head(20) %>%
  mutate(average_bl_votes = round(average_bl_votes, 2)) %>%
  hchart("bar", hcaes(x = name, y = average_bl_votes)) %>%
  hc_plotOptions(bar = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "Average BL Votes Per Game")

# Average votes per game vs player win rate
bl %>%
  filter(Season < 2019) %>%
  group_by(name) %>%
  summarise(
    average_bl_votes = mean(bl, na.rm = TRUE),
    win_pct = mean(player_win)
  ) %>%
  arrange(desc(average_bl_votes)) %>%
  head(20) %>%
  hchart("scatter", hcaes(x = average_bl_votes, y = win_pct)) %>%
  hc_plotOptions(scatter = list(dataLabels = list(enabled = TRUE, formatter = JS("function(){return(this.point.name)}")))) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "Average BL Votes vs Team Win Pct")

# Top average votes in losses
bl %>%
  filter(player_win == 0, Season < 2019) %>%
  group_by(name) %>%
  summarise(
    avg_bl_votes_in_losses = mean(bl, na.rm = TRUE),
    total_losses = n()
  ) %>%
  arrange(desc(avg_bl_votes_in_losses))


# Top average votes in losses
bl %>%
  filter(player_win == 0, bl == 3) %>%
  group_by(name) %>%
  summarise(
    three_in_a_loss = n()
  ) %>%
  arrange(desc(three_in_a_loss))


bl %>%
  filter(player_win == 0, bl == 2) %>%
  group_by(name) %>%
  summarise(
    two_in_a_loss = n()
  ) %>%
  arrange(desc(two_in_a_loss))