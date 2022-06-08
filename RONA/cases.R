library(tidyverse)
library(jsonlite)
library(anytime)
library(lubridate)
library(highcharter)
library(COVID19)

options(tibble.width = Inf)

source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# Positive Test % By Stats
# ____________________

covid_aus_states = 
  COVID19::covid19(country = "AUS", level = 2, verbose = FALSE) %>% 
  as_tibble() %>%
  select(date, state = administrative_area_level_2, confirmed, tests) %>%
  group_by(state) %>%
  arrange(state, date) %>%
  mutate(cases = confirmed - lag(confirmed,1), tests = tests - lag(tests,1)) %>%
  ungroup() %>%
  filter(date >= "2021-12-15")


covid_aus_states %>%
  group_by(date, state) %>%
  summarise(
    across(c(cases, tests), sum)
  ) %>%
  filter(tests > 0, tests > cases) %>%
  mutate(pos_test_pct = cases / tests) %>%
  # bind_rows(
  #   tibble(
  #     date = today(),
  #     state = c("Victoria", "New South Wales"),
  #     pos_test_pct = c(0.318, 0.342)
  #   )
  # ) %>%
  # filter(pos_test_pct < 0.45) %>%
  hchart("line", hcaes(x = date, y = pos_test_pct, group = state)) %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_yAxis(
    title = list(text = "Cases / Tests"),
    labels = list(
      formatter = JS(
        "function(){
          byHundred = Math.round(this.value * 100)
          return(byHundred + '%') 
        }"
      )
    )
  ) %>%
  hc_title(text = "Aus Covid") %>%
  hc_subtitle(text = "Positive Test %") %>%
  hc_legend(enabled = TRUE)


# COVID Case Data
# ____________________

covid = COVID19::covid19(country = "AUS", level = 1, verbose = FALSE) %>% as_tibble()     



covid %>%
  mutate(cases = confirmed - lag(confirmed, 1)) %>%
  mutate(month = floor_date(date, unit = "week")) %>%
  group_by(month) %>%
  summarise(
    cases = sum(cases, na.rm = T)
  ) %>%
  hchart("column", hcaes(x = month, y = cases)) %>%
  hc_add_theme(hc_theme_tmbish())

covid %>%
  mutate(cases = confirmed - lag(confirmed, 1)) %>%
  mutate(period = ifelse(date >= "2021-12-25", "Post Xmas", "Pre Xmas")) %>%
  group_by(period) %>%
  summarise(
    cases = sum(cases, na.rm = T)
  ) %>%
  mutate(
    cases = cumsum(cases)
  ) %>%
  hchart("line", hcaes(x = week, y = cases)) %>%
  hc_add_theme(hc_theme_tmbish())


# Hospitalisations
# ---------------------------------

covid %>%
  filter(date >= "2020-01-01") %>%
  select(date, hosp, icu, vent) %>%
  pivot_longer(-date) %>%
  hchart("area", hcaes(x = date, y = value, group = name), stacking = "normal") %>%
  hc_add_theme(hc_theme_tmbish()) %>%
  hc_yAxis(title = list(text = "Patients")) %>%
  hc_title(text = "Aus Covid Cases")  %>%
  hc_subtitle(text = "Hospitalisations")



base = 
  covid %>%
  mutate(cases = confirmed - lag(confirmed, 1)) %>%
  mutate(
    period = case_when(
      date >= "2020-03-01" & date <= "2020-05-01" ~ "Wave 1",
      date <= "2020-10-01" ~ "Wave 2",
      TRUE ~ "Other"
    )
  ) %>%
  group_by(period) %>%
  summarise(cases = sum(cases, na.rm = T))


tibble(
  period = c("Entire Vic Wave 1", "Entire Vic Wave 2", "NSW December 31st 2021"),
  cases = c(6932, 20160, 21151),
  group = c(1,1,2)
) %>%
hchart("bar", hcaes(x = period, y = cases, color = colorize(group, colors = c("#B1EDE8", "#FF6978")))) %>%
hc_add_theme(hc_theme_tmbish()) %>%
hc_xAxis(title = list(text = "")) %>%
hc_yAxis(title = list(text = "Total Covid Cases")) %>%
hc_title(text = "Aus Covid Cases") %>%
hc_legend(enabled = FALSE)




