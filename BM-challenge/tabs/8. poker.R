pokerTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Poker Stars",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> Simply a knockout tournament style poker game where everyone starts with equal chips.
             Like our typical poker games - only the top 3 players score points.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participants opt in or out at start of the game. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> If you make it from short stack to first place. </p>")),
             tabPanel("Results",
                      hotable("hotable8"),
                      br(),
                      actionButton("calc8","calculate",styleclass="primary",size="mini"),
                      actionButton("up8","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 8, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 80, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 10, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc8 = function(hdf) {
  hdf$Score = ifelse(hdf$Place == 1,40, ifelse(hdf$Place == 2, 25, ifelse(hdf$Place ==3, 15,0))) + hdf$Bonus.Points
  return(hdf)
}