library(tidyverse)
library(nbastatR)
library(highcharter)
library(glue)
library(furrr)
library(lubridate)

# Getting Data
# ______________

plan(multiprocess)

#gamelogs = game_logs(2010:2020)

scores = nbastatR::days_scores(game_dates = seq.Date(as_date("2009-10-01"), today(), by = "day"))

# Analysis
# ______________

scores %>%
  filter(nameTable == "LineScore") %>%
  unnest(dataTable) %>%
  head()