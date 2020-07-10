cluedoTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Board Games",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This challenge will consist of two rounds of board games:<br/>
             1. Group is split in half and plays 2 simultaneous games of Monopoly; <br/>
             2. A game of Cluedo. <br/>
             The winners of each monopoly game each recieve 20 points. The pair that wins the cluedo match also recieve 20 points each.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participation is MANDATORY. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> Win Monopoly with no monopoly higher than the pinks. Or win Cluedo whilst sacrificing a card. </p>")),
             tabPanel("Results",
                      hotable("hotable12"),
                      br(),
                      actionButton("calc12","calculate",styleclass="primary",size="mini"),
                      actionButton("up12","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team/Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 10, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 80, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 10, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )


calc12 = function(hdf) {
  hdf$Score = ifelse(hdf$Monopoly.Win == 1,20,0) + ifelse(hdf$Cluedo.Win == 1,20,0) 
  return(hdf)
}