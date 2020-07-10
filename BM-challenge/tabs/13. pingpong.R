pingpongTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Table Tennis",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This challenge will be a seeded knock-out tournament of table tennis. Points will be awarded based on the
             maximum round played in. The tournament champion recieves an extra 20 points.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participants must opt in or out before start of tournament. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> Behind the back winner. </p>")),
             tabPanel("Results",
                      hotable("hotable13"),
                      br(),
                      actionButton("calc13","calculate",styleclass="primary",size="mini"),
                      actionButton("up13","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 8, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 100, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 10, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )


calc13 = function(hdf) {
  power = ifelse(hdf$Pong.Rank == 0,0,(10-hdf$Pong.Rank)^2)
  scaled = power / (sum(power)/80)
  pongScore = round(scaled,0)
  hdf$Score = pongScore + 20 * hdf$Champion
  return(hdf)
}