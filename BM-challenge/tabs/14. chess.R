chessTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Chess",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This is a knockout round robin chess tournament. Participants will be seeded according to me, so that
             the most even/exciting matches are saved for the final.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participants must opt in or out before start of tournament. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> NA </p>")),
             tabPanel("Results",
                      hotable("hotable14"),
                      br(),
                      actionButton("calc14","calculate",styleclass="primary",size="mini"),
                      actionButton("up14","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 6, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 120, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", NA, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc14 = function(hdf) {
  power = ifelse(hdf$Chess.Rank == 0,0,(10-hdf$Chess.Rank)^2)
  scaled = power / (sum(power)/120)
  chessScore = round(scaled,0)
  hdf$Score = chessScore
  return(hdf)
}