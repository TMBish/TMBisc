frizTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Frisbee Golf",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This round consists of 2 components (again): <br/>
             1. A 9 hole course of frisbee golf which will be set-up around the property. The hole is a hula hoop hanging from
             a tree. Your score is dependent on how many throws it takes you to complete the 9
             hole course. Like golf you obviously want this score to be as low as possible. <br/>
             2. Following this game will be a match of ultimate frisbee. The winning team will get a 1.5 multiplier applied to their individual score from the golf round.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Participants will opt in or out before the start of the golf round. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> Get one hole-in-1 </p>")),
             tabPanel("Results",
                      hotable("hotable10"),
                      br(),
                      actionButton("calc10","calculate",styleclass="primary",size="mini"),
                      actionButton("up10","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Team/Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 6, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 80, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 10, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc10 = function(hdf) {
  power = ifelse(hdf$Golf.Rank == 0,0,(10-hdf$Golf.Rank)^2)
  scaled = power / (sum(power)/80)
  frizScore = round(scaled,0)
  hdf$Score = frizScore * ifelse(hdf$Ultimate.Win == 1, 1.5,1) + hdf$Bonus.Points
  return(hdf)
}