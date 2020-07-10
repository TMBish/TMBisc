damTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Dam Diving",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> Each team must (1 at a time / survivor style) run from the starting line and dive into the dam to
             retrieve the golf balls successfully hit to the bottom of the dam. Only one member of each team is allowed in
             the dam at a time. The team that retrieves the most balls wins.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participation is MANDATORY. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> NA </p>")),
             tabPanel("Results",
                      hotable("hotable6"),
                      br(),
                      actionButton("calc6","calculate",styleclass="primary",size="mini"),
                      actionButton("up6","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 10, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 75, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", NA, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc6 = function(hdf) {
  hdf$Score = 15*hdf$Team.Win
  return(hdf)
}