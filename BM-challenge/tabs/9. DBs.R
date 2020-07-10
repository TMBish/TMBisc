DBTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Double Black Challenge",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This round is the classic fridge pack of double blacks challenge. Many have tried, few have succeeded. Tonight may be your night.
             This time there will be a slight variation. There will be 2 stages: <br/>
             1. Team based -  each member of your team must complete DB x before anyone in your team can crack DB x+1. <br/>
             2. Once all team members have consumed 5 DBs it's every man for himself. <br/> <br/>
             The first to DB 10 earns 20 points. 25 points are awarded to anyone who makes it to DB 10. Teams for the team component are evens and odds on the leaderboard.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participation to DB 5 is mandatory. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> 10 DBs in under 1.5 hrs </p>")),
             tabPanel("Results",
                      hotable("hotable9"),
                      br(),
                      actionButton("calc9","calculate",styleclass="primary",size="mini"),
                      actionButton("up9","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team/Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 10, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", "Max score is 45", icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 10, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc9 = function(hdf) {
  power = ifelse(hdf$DB.Rank == 0,0,(10-hdf$DB.Rank)^2)
  scaled = power / (sum(power)/80)
  dbScore = round(scaled,0)
  hdf$Score = dbScore + hdf$Finish.Bonus
  return(hdf)
}