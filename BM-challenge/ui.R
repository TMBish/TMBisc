library(shinydashboard)

header <- dashboardHeader(
  title = "BM Challenge"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Leaderboard", tabName = "leaderboard", icon = icon("sort")),
    menuItem("Challenge 1 - Eating", tabName = "eating", icon = icon("cutlery")),
    menuItem("Challenge 2 - Video Games", tabName = "videog", icon = icon("gamepad")),
    menuItem("Challenge 3 - Drinking Games", tabName = "stackcup", icon = icon("bullseye")),
    menuItem("Challenge 4 - Bench Press", tabName = "bench", icon = icon("female")),
    menuItem("Challenge 5 - Golf", tabName = "golf", icon = icon("bomb")),
    menuItem("Challenge 6 - Dam Diving", tabName = "dam", icon = icon("tint")),
    menuItem("Challenge 7 - Basketball", tabName = "bball", icon = icon("lock")),
    menuItem("Challenge 8 - Poker", tabName = "poker", icon = icon("paypal")),
    menuItem("Challenge 9 - DB Challenge", tabName = "DBs", icon = icon("ambulance")),
    menuItem("Challenge 10 - Frisbee Golf", tabName = "friz", icon = icon("send")),
    menuItem("Challenge 11 - Pyro", tabName = "pyro", icon = icon("fire")),
    menuItem("Challenge 12 - Board Games", tabName = "cluedo", icon = icon("group")),
    menuItem("Challenge 13 - Ping Pong", tabName = "pong", icon = icon("circle-o")),
    menuItem("Challenge 14 - Chess", tabName = "chess", icon = icon("arrows")),
    menuItem("Challenge 15 - Tha Final Challenge", tabName = "escape", icon = icon("gears"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "leaderboard",
            box(width = 12, title = "Leaderboard", status = "primary",

#                 fluidRow(
#                   column(1, h3('')),
#                   column(3, h3('Participant')),
#                   column(3, h3('Score')),
#                   column(3, h3('Odds'))
#                 ),
#                 lapply(1:10, function(i) {
#                   fluidRow(
#                     column(1,h2(paste0(i))),
#                     column(3,textOutput(paste0("lead",i))),
#                     column(3,textOutput(paste0("points",i))),
#                     column(3,textOutput(paste0("odds",i)))
#                   )
#                 })
            
            uiOutput("matrix")
            )
            
    ),
    tabItem(tabName = "eating",
            eatingTab
    ),
    tabItem(tabName = "videog",
            videogTab
    ),
    tabItem(tabName = "stackcup",
            stackcupTab
    ),
    tabItem(tabName = "bench",
            benchTab
    ),
    tabItem(tabName = "golf",
            golfTab
    ),
    tabItem(tabName = "dam",
            damTab
    ),
    tabItem(tabName = "bball",
            bballTab
    ),
    tabItem(tabName = "poker",
            pokerTab
    ),
    tabItem(tabName = "DBs",
            DBTab
    ),
    tabItem(tabName = "friz",
            frizTab
    ),
    tabItem(tabName = "pyro",
            pyroTab
    ),
    tabItem(tabName = "cluedo",
            cluedoTab
    ),
    tabItem(tabName = "pong",
            pingpongTab
    ),
    tabItem(tabName = "chess",
            chessTab
    ),
    tabItem(tabName = "escape",
            escapeTab
    )
  )
)

dashboardPage(skin = "black",
              header,
              sidebar,
              body
)