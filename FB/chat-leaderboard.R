library(tidyverse)
library(jsonlite)
library(anytime)
library(lubridate)
library(highcharter)

# Some Extra Stuff
# ______________

# Highcharts Theme
source("https://raw.githubusercontent.com/TMBish/TMBisc/master/HC/hc_theme_tmbish.R")

# Hoops Only Chat Data
# ____________________

#json = jsonlite::read_json("data/hoops-only-log-v1.json")

json = jsonlite::read_json("data/corona-only-20200316.json")
  
#df = list.files("data/threads-20200323/", full.names=TRUE) %>%
    
thread = "data/threads-20200323/"
thread = "data/threads-20200404/"

df = list.files(thread, full.names=TRUE) %>%
  map_dfr(function(t) {
    read_json(t) %>%
      pluck(., "messages") %>%
      enframe() %>% 
      mutate(
        sender = value %>% map_chr("sender_name"),
        content = value %>% map_chr(.f = function(x) {if(is.null(x$content)) return(NA); x$content}),
        reactions = value %>% map_dbl(.f = function(x){if(is.null(x$reactions)) return(NA); length(x$reactions)}),
        reactors = value %>% map(.f = function(x){if(is.null(x$reactions)) return(NULL); tibble(reactor = x$reactions %>% map_chr("actor"))}),
        is_photo = value %>% map_lgl(.f = function(x){if(is.null(x$photo)) return(FALSE); TRUE}),
        timestamp = value %>% map_chr("timestamp_ms"),
        type = value %>% map_chr("type")
      ) %>%
      select(-name, -value) %>%
      mutate(
        datetime = 
          timestamp %>% 
          str_remove("\\.0+") %>%
          str_remove("\\d{3}$") %>%
          as.numeric() %>%
          anytime(),
        date = as_date(datetime)
      ) %>%
      mutate(
        thread = 
          t %>%
          str_remove(thread) %>%
          str_remove("_\\d{1}.json$") %>%
          str_replace_all("-", " ")
      )
  })

# Graphs
# ____________________

df %>%
  group_by(thread) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = thread, y = messages)) %>%
  hc_title(text = "FB Message Threads") %>%
  hc_yAxis(title = list(text = "Total Messages")) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_tmbish())


df %>%
  group_by(sender, thread) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = sender, y = messages, group = thread)) %>%
  hc_title(text = "FB Message Threads") %>%
  hc_yAxis(title = list(text = "Total Messages")) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE), stacking = "percent",  borderRadius = 0)) %>%
  hc_add_theme(hc_theme_tmbish())


# Messages Per Active Day
df %>%
  group_by(thread) %>%
  summarise(
    messages = n(),
    max_date = max(date),
    min_date = min(date)
  ) %>%
  mutate(
    days = (max_date-min_date) %>% as.numeric()
  ) %>%
  mutate(
    messages_per_day = round(messages / days, 1)
  ) %>%
  hchart("column", hcaes(x = thread, y = messages_per_day)) %>%
  hc_title(text = "FB Message Threads") %>%
  hc_yAxis(title = list(text = "Messages / Day")) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE),  borderRadius = 0)) %>%
  hc_add_theme(hc_theme_tmbish())



# Cumulative
df %>%
  select(thread, date) %>% mutate(message = 1) %>%
  complete(thread, date) %>%
  group_by(thread, date) %>%
  summarise(messages = sum(message, na.rm = TRUE)) %>%
  ungroup() %>%
  group_by(thread) %>%
  mutate(messages = cumsum(messages)) %>%
  filter(date > "2019-01-01") %>%
  hchart("line", hcaes(x = date, y = messages, group = thread)) %>%
  hc_title(text = "FB Message Threads") %>%
  hc_yAxis(title = list(text = "Cumulative Messages")) %>%
  hc_xAxis(title = list(text = "")) %>%
  hc_add_theme(hc_theme_tmbish())



