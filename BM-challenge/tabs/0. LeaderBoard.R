library(stringr)
output = "fluidRow(
                fluidRow(
                  column(3, h3('')),
                  column(3, h3('Participant')),
                  column(3, h3('Score'')),
                  column(3, h3('Odds'))
                ),"

for (i in 1:9) {
  output = paste0(output,
                  "fluidRow(
                        column(3, imageOutput('img",i,"')),
                        column(3, verbatimTextOutput('lead",i,"')),
                        column(3, verbatimTextOutput('points",i,"')),
                        column(3, verbatimTextOutput('odds",i,"'))
                      )"
  )
}

output = str_replace_all(output, "[\r\n]" , "")

leaderBTab = 
  output




