golfTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Golf",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> Each team will receive 100 golf balls. The challenge is to chip the balls into the dam.
             The team which pockets the most balls in the dam earns 10 points each. Further, for each 10 balls
             successfully chipped into the dam by a team, all team members earn 1 point.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participation is MANDATORY. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> An individual who chips a ball through one of the 3 hula-hoops in the dam earns 25 points.</p>")),
             tabPanel("Results",
                      hotable("hotable5"),
                      br(),
                      actionButton("calc5","calculate",styleclass="primary",size="mini"),
                      actionButton("up5","upload",styleclass="danger")
                      )
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 10, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 50-100, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 25, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )


calc5 = function(hdf) {
  hdf$Score = 10*hdf$Team.Win + floor(hdf$Num.Balls/10) + hdf$Bonus.Points
  return(hdf)
}