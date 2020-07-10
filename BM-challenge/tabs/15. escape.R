escapeTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Final Challenge",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This is a team based challenge. Teams will be (1,4,6), (2,3,5), and (7,8,9,10) positions on the leaderboard.
             teams not yet having completed the challenge wait in the waiting room. After you complete the challenge you may
             join the viewing room with me.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participation is MANDATORY. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> There will be an individual bonus challenge during this challenge. </p>")),
             tabPanel("Results",
                      hotable("hotable15"),
                      br(),
                      actionButton("calc15","calculate",styleclass="primary",size="mini"),
                      actionButton("up15","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team/Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 10, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 150, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 30, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc15 = function(hdf) {
  power = ifelse(hdf$Final.Rank == 0,0,(10-hdf$Final.Rank)^2)
  scaled = power / (sum(power)/200)
  escapeScore = round(scaled,0)
  hdf$Score = escapeScore + hdf$Bonus.Points
  return(hdf)
}