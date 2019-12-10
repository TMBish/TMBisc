library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(furrr)


# Some Extra Stuff
# ______________

# Highcharts Theme
source("https://raw.githubusercontent.com/TMBish/lab_posts/master/00_utilities/highcharts-theme.R")

# Getting Data
# ______________

plan(multiprocess)

gamelogs = game_logs(2000:2020)

# Images Nails
player_photo = 
  nbastatR::nba_players() %>%
  select(namePlayer, urlPlayerThumbnail)

# Free Throws
# ______________

# FTA Per Game
fta = 
  gamelogs %>%
  filter(typeSeason == "Regular Season") %>%
  group_by(namePlayer, slugSeason) %>%
  summarise(fta = mean(fta), ftm = mean(ftm)) %>%
  arrange(desc(fta)) %>%
  head(20)


ftList = 
  fta %>%
  inner_join(player_photo) %>%
  ungroup() %>%
  mutate(pointTitle = str_c(namePlayer, "-", slugSeason)) %>%
  select(pointTitle, x = fta, y = ftm, urlPlayerThumbnail) %>%
  pmap(
   function(pointTitle, x,y,urlPlayerThumbnail) {
     list(
       x = x,
       y = y,
       pointTitle = pointTitle,
       marker = list(symbol = glue("url({urlPlayerThumbnail})"), height = 60, width = 75)
     ) 
   }
  ) %>%
  list(
    name = "FT Made / Attempted",
    data = .
  ) %>%
  list()

# League Average FT%
ftAvg = 
  gamelogs %>%
  filter(typeSeason == "Regular Season") %>%
  group_by(namePlayer, slugSeason) %>%
  summarise(fta = mean(fta), ftm = mean(ftm)) %>%
  ungroup() %>%
  mutate(ft_pct = ftm / fta) %>%
  filter(fta > 1) %>%
  summarise(avg = mean(ft_pct)) %>%
  pull()

ftAvgLine = 
  tibble(
    x = seq(0, 15, by = 0.5),
    y = seq(0, 15, by = 0.5) * ftAvg
  )


highchart() %>%
  hc_chart(type = "scatter") %>%
  hc_add_series_list(ftList) %>%
  hc_plotOptions(
    scatter = 
      list(
        dataLabels = list(
          enabled = TRUE, 
          formatter = JS("function(){return(this.point.pointTitle)}"),
          y = 47
        ),
        jitter = list(x = 0.1, y = 0.01)
      )
  ) %>%
  hc_add_series(
    ftAvgLine, "line", hcaes(x = x, y = y), 
    name = "Avg FT% (74%)", color = "#FCDDBC", marker = list(enabled = FALSE), dashStyle = "LongDash"
  ) %>%
  hc_add_theme(high_tmbish()) %>%
  hc_title(text = "Freethrows Since 1989-90") %>%
  hc_subtitle(text = "Top 20 Individual Seasons By Attempts") %>%
  hc_yAxis(
    title = list(text = "Free Throws Made Per Game"),
    min = 0.8 * min(fta$ftm)
  ) %>%
  hc_xAxis(
    title = list(text = "Free Throws Attempted Per Game"),
    min = 0.95 * min(fta$fta),
    max = 1.05 * max(fta$fta)
  )


# Luka Doncic
# _____________________


cumulativeFTA = 
  gamelogs %>%
  filter(typeSeason == "Regular Season") %>%
  group_by(namePlayer, slugSeason, dateGame) %>%
  group_by(namePlayer) %>%
  arrange(dateGame) %>%
  mutate(game_number = row_number()) %>%
  ungroup() %>%
  filter(game_number <= max(filter(., namePlayer=="Luka Doncic") %>% pull(game_number) %>% max()))

top10EarlyCareer = 
  cumulativeFTA %>%
  group_by(namePlayer) %>%
  summarise(
    fta = sum(fta)
  ) %>%
  arrange(desc(fta)) %>%
  head(10) %>%
  select(namePlayer) %>%
  bind_rows(
    tibble(
      namePlayer = "James Harden"
    )
  )
  
cumulativeFTA %>%
  inner_join(top10EarlyCareer) %>%
  filter(namePlayer %>% str_detect("Luka|Shaq|Hard|Joel")) %>%
  group_by(namePlayer) %>%
  mutate(cumulative_fta = cumsum(fta)) %>%
  ungroup() %>%
  hchart("line", hcaes(x = game_number, y = cumulative_fta, group = namePlayer)) %>%
  hc_add_theme(high_tmbish())


# Free Throws Over Time
# _____________________


topScorers = 
  gamelogs %>%
  filter(typeSeason == "Regular Season") %>%
  group_by(namePlayer, slugSeason) %>%
  summarise(
    ppg = mean(pts),
    ftm = mean(ftm)
  ) %>%
  ungroup() %>%
  group_by(slugSeason) %>%
  mutate(scorer_rank = dense_rank(-ppg)) %>%
  filter(scorer_rank <= 5) %>%
  ungroup()

topScorers %>%
  group_by(slugSeason) %>%
  summarise(
    pts = sum(ppg),
    ftm = sum(ftm)
  ) %>%
  mutate(
    ftPct = ftm / pts
  ) %>%
  hchart("line", hcaes(x = slugSeason, y = ftPct))


# Threes
# ______________

# 3PM
threes = 
  gamelogs %>%
  filter(typeSeason == "Regular Season") %>%
  group_by(namePlayer, slugSeason) %>%
  summarise(fg3m = mean(fg3m), fg3a = mean(fg3a)) %>%
  arrange(desc(fg3m)) %>%
  head(20)


fg3mList = 
  threes %>%
  inner_join(player_photo) %>%
  ungroup() %>%
  mutate(pointTitle = str_c(namePlayer, "-", slugSeason)) %>%
  select(pointTitle, y = fg3m, x = fg3a, urlPlayerThumbnail) %>%
  pmap(
    function(pointTitle, x,y,urlPlayerThumbnail) {
      list(
        x = x,
        y = y,
        pointTitle = pointTitle,
        marker = list(symbol = glue("url({urlPlayerThumbnail})"), height = 60, width = 75)
      ) 
    }
  ) %>%
  list(
    name = "Three Points",
    data = .
  ) %>%
  list()

highchart() %>%
  hc_chart(type = "scatter") %>%
  hc_add_series_list(fg3mList) %>%
  hc_plotOptions(
    scatter = 
      list(
        dataLabels = list(enabled = TRUE, formatter = JS("function(){return(this.point.pointTitle)}")),
        jitter = list(x = 0.1, y = 0.01)
      )
  ) %>%
  hc_add_theme(hc_theme_elementary()) %>%
  hc_title(text = "Three Pointers Since 2000") %>%
  hc_subtitle(text = "Top 20 Seasons By Makes") %>%
  hc_yAxis(title = list(text = "3 Pointers Made Per Game")) %>%
  hc_xAxis(title = list(text = "3 Pointers Attempted Per Game"))

