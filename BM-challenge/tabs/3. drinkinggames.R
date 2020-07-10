stackcupTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Drinking Games",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
                      HTML(
                        "<strong> <big> Overview </big> </strong> <br/>
             <p> This round will involve 2 drinking games: beer pong and stackcup. <br/>
             1. Stack cup - Last man standing, you are eliminated if: you get stacked more than 5 times or you quit. <br/>
             2. Peer pong - Top 6 from stack cup enter a 2 person round robin for the beer pong title. Teams will be 1-6, 2-5, 3-4. <br/>
             <br/>
             The points will be awarded as follows: winning beer pong duo gets 10 points each, stack cup points awarded by order of
             elimination. Total is dependent on number of participants.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> If enters stack cup and not actively sabotages beer pong. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> If meat grinder successful for 3 consecutive stacks both grinders are awarded 5 points. </p>")),
             tabPanel("Results",
                      hotable("hotable3"),
                      br(),
                      actionButton("calc3","calculate",styleclass="primary",size="mini"),
                      actionButton("up3","upload",styleclass="danger")
                      
             )
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team & Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 6, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 120, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 5, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )


calc3 = function(hdf) {
  power = ifelse(hdf$Stack.Rank == 0,0, (10-hdf$Stack.Rank)^2)
  scaled = power / (sum(power)/100)
  stackScore = round(scaled,0)
  hdf$Score = stackScore + hdf$Bonus.Points + 10*hdf$Beer.Pong
  return(hdf)
}