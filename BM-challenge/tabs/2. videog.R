videogTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Video Games",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
                      HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This round will involve 3 games: CoD 4, Smash Bros, and James Bond Nightfire. The challenge will follow the following
             format: <br/>
             1. CoD 4 LaN Party - Teams of 5 (rotating 1 out at a time) playing 12 search and destroy matches. <br/>
             2. Smash Brawl - Every man for himself, players will be ranked 1-10 at the end of the session. <br/>
             3. James Bond - Top 4 ranked (by running point total) make it through to 4 man deathmatch. <br/>
             <br/>
             The points will be awarded as follows: 10 points for each player on the winning team for CoD4, points according to smash ranking such that
             #1 gets 20 points and #10 gets 2 points, and 25 points for the winner of the James Bond deathmatch.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participation is MANDATORY </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> NA </p>")),
             tabPanel("Results",
                      hotable("hotable2"),
                      br(),
                      actionButton("calc2","calculate",styleclass="primary",size="mini"),
                      actionButton("up2","upload",styleclass="danger")
                      )
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team & Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 10, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", "Maximum score is 55", icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", "NA", icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc2 = function(hdf) {
  power = ifelse(hdf$Smash.Rank == 0,0, (10-hdf$Smash.Rank)^2)
  scaled = power / (sum(power)/80)
  smashScore = round(scaled,0)
  hdf$Score = smashScore + 10*hdf$COD4 + 25*hdf$Night.Fire
  return(hdf)
}
