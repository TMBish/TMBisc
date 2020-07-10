pyroTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Pyro: wood chopping and fire construction",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> This is a time-trial. Each participant will recieve:<br/>
             1. One log; <br/>
             2. A fire lighter; <br/>
             3. 3 sheets of newspaper; and <br/>
             4. An axe. <br/>
             Your timer stops when your fire is going to the satisfaction of the chief justice: Tom B.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> A piece of the log must be alight. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> NA </p>")),
             tabPanel("Results",
                      hotable("hotable11"),
                      br(),
                      actionButton("calc11","calculate",styleclass="primary",size="mini"),
                      actionButton("up11","upload",styleclass="danger"))
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 4, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 100, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", NA, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )


calc11 = function(hdf) {
  power = ifelse(hdf$Fire.Rank == 0,0,(10-hdf$Fire.Rank)^2)
  scaled = power / (sum(power)/100)
  pyroScore = round(scaled,0)
  hdf$Score = pyroScore
  return(hdf)
}