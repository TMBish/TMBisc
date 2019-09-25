library(tidyverse)
library(jsonlite)
library(anytime)
library(lubridate)
library(highcharter)
library(here)

# Chats Only Chat Data
# ____________________

json = jsonlite::read_json("data/chats-log.json")

# Data Frame
# ____________________

df = 
  json %>% 
  pluck("messages") %>% 
  enframe() %>% 
  mutate(
    sender = value %>% map_chr("sender_name"),
    content = value %>% map_chr(.f = function(x) {if(is.null(x$content)) return(NA); x$content}),
    reactions = value %>% map_dbl(.f = function(x){if(is.null(x$reactions)) return(NA); length(x$reactions)}),
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
  )

# Graphs
# ____________________

df %>%
  group_by(sender) %>%
  summarise(
    messages = n()
  ) %>%
  arrange(desc(messages)) %>%
  hchart("column", hcaes(x = sender, y = messages), color = "#7DCFB6") %>%
  hc_title(text = "Random Bantz and Chats") %>%
  hc_subtitle(text = "Total volume of messages") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_google())


df %>%
  group_by(sender) %>%
  summarise(
    messages = n(),
    reactions = sum(reactions, na.rm = TRUE)
  ) %>%
  mutate(
    reactions_per100 = reactions / messages
  )  %>%
  arrange(desc(reactions_per100)) %>%
  hchart("column", hcaes(x = sender, y = reactions_per100), color = "#7DCFB6") %>%
  hc_title(text = "Random Bantz and Chats") %>%
  hc_subtitle(text = "% of messages that get a reaction") %>%
  hc_yAxis(labels = list(formatter = JS("function(){return(Math.round(this.value * 1000) / 10 + '%')}"))) %>%
  hc_plotOptions(
    column = list(dataLabels = list(enabled = TRUE, formatter = JS("function(){return(Math.round(this.y * 1000) / 10 + '%')}")))
  )

df %>%
  group_by(sender) %>%
  summarise(
    photos = sum(is_photo)
  ) %>%
  arrange(desc(photos)) %>%
  hchart("column", hcaes(x = sender, y = photos), color = "#7DCFB6") %>%
  hc_title(text = "Random Bantz and Chats") %>%
  hc_subtitle(text = "Total photos posted") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_google())



df %>%
  mutate(
    context_less_photo = ifelse(is_photo & !(lead(sender) == sender | lag(sender) == sender), TRUE, FALSE)
  ) %>%
  group_by(sender) %>%
  summarise(
    context_less_photos = sum(context_less_photo)
  ) %>%
  arrange(desc(context_less_photos)) %>%
  hchart("column", hcaes(x = sender, y = context_less_photos), color = "#7DCFB6") %>%
  hc_title(text = "Random Bantz and Chats") %>%
  hc_subtitle(text = "# of context free photos / screenshots") %>%
  hc_plotOptions(column = list(dataLabels = list(enabled = TRUE))) %>%
  hc_add_theme(hc_theme_google())

df %>%
  group_by(date = floor_date(date, unit = "months"), sender) %>%
  summarise(messages = n()) %>%
  ungroup() %>%
  group_by(sender) %>%
  mutate(cumulative_posts = cumsum(messages)) %>%
  hchart("line", hcaes(x = date, y = cumulative_posts, group = sender)) %>%
  hc_title(text = "Random Bantz and Chats") %>%
  hc_subtitle(text = "Cumulative Posts") %>%
  hc_add_theme(hc_theme_google())



# Wordclouds
# ____________________

library(wordcloud2)
library(tidytext)

build_word_cloud = function(.sender) {
  
  counts = 
    df %>%
    select(sender, content) %>%
    filter(!is.na(content)) %>%
    unnest_tokens(word, content) %>%
    group_by(sender, word) %>%
    summarise(
      freq = n()
    ) %>%
    ungroup() %>%
    filter(sender == .sender) %>%
    select(-sender) %>%
    anti_join(get_stopwords())

  wordcloud2(counts)


}


build_word_cloud("Christian Burgin")
build_word_cloud("Tom Bishop")
build_word_cloud("Hannah Elisabeth")
build_word_cloud("Tess O'Meara")
build_word_cloud("Paul McGrath")
build_word_cloud("Hannah Tarrant")
build_word_cloud("Dom Potter")
build_word_cloud("Lucy McGrath")




