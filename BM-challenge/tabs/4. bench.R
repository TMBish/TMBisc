benchTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "Bench Press",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
              HTML(
              "<strong> <big> Overview </big> </strong> <br/>
             <p> 2 rep max on the bench press. Points awarded by rank order depending on number of participants.
             </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> Consensus opinion will be used. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> 90 kgs, 2 reps. </p>")),
             tabPanel("Results",
                      hotable("hotable4"),
                      br(),
                      actionButton("calc4","calculate",styleclass="primary",size="mini"),
                      actionButton("up4","upload",styleclass="danger")
                      
                      )
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 2, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 80, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 20, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc4 = function(hdf) {
  power = ifelse(hdf$Strong.Rank == 0,0, (10-hdf$Strong.Rank)^2)
  scaled = power / (sum(power)/80)
  benchScore = round(scaled,0)
  hdf$Score = benchScore + hdf$Bonus.Points
  return(hdf)
}