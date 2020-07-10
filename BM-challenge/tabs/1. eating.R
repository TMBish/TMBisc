eatingTab = 
  fluidRow(
    column(width = 8,
           tabBox(
             title = "The Eating Challange",
             id = "tabset1", height = "600", width = 12,
             tabPanel("Challenge Description",
                      HTML(
                        "<strong> <big> Overview </big> </strong> <br/>
             <p> Round based eating challenge at Pizza Hut Ballarat. A round consists of eating a slice of pizza (topping of your choice).
             Each pizza round will go for 3 minutes. Every 5 rounds there is what's called a 'sundae round' where you must eat a sundae from the sundae bar.
             The sundae rounds will go for 10 minutes each. </p> <br/> <br/>
             <strong> <big> What constitutes participation? </big> </strong> <br/>
             <p> To be considered a participant in this challenge you must make it to round 6. </p> <br/> <br/>
             <strong> <big> How do I win bonus points? </big> </strong> <br/>
             <p> Make it to round 15. </p>")),
             tabPanel("Results",
                      
                        hotable("hotable1"),
                        br(),
                        actionButton("calc1","calculate",styleclass="primary",size="mini"),
                        actionButton("up1","upload",styleclass="danger")
                      
             )
           )
    ),
    column(width = 4,
           valueBox("Team/Individual", "Individual", icon = icon("user"), width = NULL, color = "olive"),
           valueBox("Min. Participants", 6, icon = icon("users"), width = NULL, color = "olive"),
           valueBox("Points Avaliable", 150, icon = icon("money"), width = NULL, color = "olive"),
           valueBox("Bonus Points?", 20, icon = icon("asterisk"), width = NULL, color = "olive")
    )
  )

calc1 = function(hdf) {
  power = (10-hdf$Individual.Rank)^2
  scaled = power / (sum(power)/150)
  hdf$Score = round(scaled + hdf$Bonus.Points,0)
  return(hdf)
}

