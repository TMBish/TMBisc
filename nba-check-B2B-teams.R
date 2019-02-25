library(tidyverse)
library(rvest)
library(lubridate)
library(glue)
library(janitor)

# Purpose -----------------------------------------------------------------

# Find the list of NBA teams that play twice in the next 2 days for fantasy  basketball reasons

# Function ----------------------------------------------------------------

# Get fixture from basketball reference
get_fixture_bball_ref = function(.month, .year) {

    schedTable =
        "https://www.basketball-reference.com/leagues/NBA_{.year}_games-{.month}.html" %>%
        glue() %>%
        read_html() %>%
        html_node(xpath = "//table[@id = 'schedule']") %>%
        html_table() %>%
        clean_names() %>%
        mutate(date = mdy(date)) %>%
        select(date, away = visitor_neutral, home = home_neutral)

}

get_b2b_teams = function(.schedDF, .date = today()) {

    schedUDF =
        .schedDF %>%
        select(date, team = home, opp = away) %>%
        union_all(
            .schedDF %>%
            select(date, team = away, opp = home)
        )

    schedUDF %>%
        filter(
            date >= .date, date <= .date + days(1)
        ) %>%
        group_by(team) %>%
        mutate(games= n()) %>%
        ungroup() %>%
        filter(games > 1) %>%
        select(team, opp, date) %>%
        group_by(team) %>%
        arrange(date) %>%
        mutate(col = row_number()) %>%
        ungroup() %>%
        mutate(col = str_c("game_", col)) %>%
        select(-date) %>%
        spread(col, opp)

}

order_teams_by_game_number = function(.schedDF) {

    schedUDF =
        .schedDF %>%
        select(date, team = home, opp = away) %>%
        union_all(
            .schedDF %>%
                select(date, team = away, opp = home)
        )


    td = today()-days(1)
    end_of_week = td + days(8 - wday(td))

    schedUDF %>%
        filter(
            date >= td, date <= end_of_week
        ) %>%
        group_by(team) %>%
        summarise(games= n()) %>%
        arrange(desc(games))

}


# Execution ---------------------------------------------------------------

# Check what teams have a back to back for fantasy purposes
month_0 = today() %>% month(label = TRUE, abbr = FALSE) %>% str_to_lower()
month_1 = (today() + months(1)) %>% month(label = TRUE, abbr = FALSE) %>% str_to_lower()

year_0 = today() %>% year()
year_1 = (today() + months(1)) %>% year()

schedDF =
    pmap_dfr(
        .l = list(
            month = c(month_0, month_1),
            year = c(year_0, year_1)
        ),
        .f = function(month, year) {get_fixture_bball_ref(month, year)}
    )

# Get Back 2 Back Teams
get_b2b_teams(schedDF)
get_b2b_teams(schedDF, .date = today() + days(1))
get_b2b_teams(schedDF, .date = today() + days(2))

# Team games this week
order_teams_by_game_number(schedDF)
