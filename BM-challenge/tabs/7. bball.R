bballTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Bball",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This will depend on the number of participants. Assuming full participation there will be 2 stages: <br/>
             1. A team based (5 on 5) match to 21 points. <br/>
             2. A 1v1 King tournament; first to 10. <br/> <br/>
             The outcome of the team match splits the field into 2 seperate segments The winning team's king tournament
             has a points pool of 60 points whereas the losing team's is only 40 points.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participants opt in or out at start of team match. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> 20 points if you get to 10 points before another player in your pool has 3. </p>")),
             tabPanel("Results",
                      hotable("hotable7"),
                      br(),
                      actionButton("calc7","calculate",styleclass="primary",size="mini"),
                      actionButton("up7","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team/Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 5, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 100, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 20, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )


calc7 = function(hdf) {
  power = ifelse(hdf$Pool.Rank == 0,0,(10-hdf$Pool.Rank)^2)
  scaled = ifelse(hdf$Team.Win == 1, power / (255/60),power / (230/32)) 
  ballScore = round(scaled,0)
  hdf$Score = ballScore + hdf$Bonus.Points
  return(hdf)
}