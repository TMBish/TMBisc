
function(input, output, session) {
  
  #tab1
  output$hotable1 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Individual.Rank" = as.numeric(seq(1,9)),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  
  observeEvent(input$calc1,{output$hotable1 = renderHotable({calc1(hot.to.df(input$hotable1))})})
  observeEvent(input$up1,{upload(input$hotable1,1)})
  
  #tab2
  output$hotable2 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "COD4" = c(rep(0,5),rep(1,5)),
      "Smash.Rank" = as.numeric(seq(1,9)),
      "Night.Fire" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc2,{output$hotable2 = renderHotable({calc2(hot.to.df(input$hotable2))})})
  observeEvent(input$up2,{upload(input$hotable2,2)})
  
  #tab3
  output$hotable3 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Stack.Rank" = as.numeric(seq(1,9)),
      "Beer.Pong" = rep(0,9),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc3,{output$hotable3 = renderHotable({calc3(hot.to.df(input$hotable3))})})
  observeEvent(input$up3,{upload(input$hotable3,3)})
  
  #tab4
  output$hotable4 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Strong.Rank" = as.numeric(seq(1,9)),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc4,{output$hotable4 = renderHotable({calc4(hot.to.df(input$hotable4))})})
  observeEvent(input$up4,{upload(input$hotable4,4)})
  
  #tab5
  output$hotable5 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Team.Win" = rep(0,9),
      "Num.Balls" = rep(0,9),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc5,{output$hotable5 = renderHotable({calc5(hot.to.df(input$hotable5))})})
  observeEvent(input$up5,{upload(input$hotable5,5)})
  
  #tab6
  output$hotable6 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Team.Win" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc6,{output$hotable6 = renderHotable({calc6(hot.to.df(input$hotable6))})})
  observeEvent(input$up6,{upload(input$hotable6,6)})
  
  #tab7
  output$hotable7 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Team.Win" = rep(0,9),
      "Pool.Rank" = rep(0,9),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc7,{output$hotable7 = renderHotable({calc7(hot.to.df(input$hotable7))})})
  observeEvent(input$up7,{upload(input$hotable7,7)})
  
  #tab8
  output$hotable8 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Place" = rep(0,9),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc8,{output$hotable8 = renderHotable({calc8(hot.to.df(input$hotable8))})})
  observeEvent(input$up8,{upload(input$hotable8,8)})
  
  #tab9
  output$hotable9 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "DB.Rank" = rep(0,9),
      "Finish.Bonus" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc9,{output$hotable9 = renderHotable({calc9(hot.to.df(input$hotable9))})})
  observeEvent(input$up9,{upload(input$hotable9,9)})
  
  #tab10
  output$hotable10 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Golf.Rank" = rep(0,9),
      "Ultimate.Win" = rep(0,9),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc10,{output$hotable10 = renderHotable({calc10(hot.to.df(input$hotable10))})})
  observeEvent(input$up10,{upload(input$hotable10,10)})
  
  #tab11
  output$hotable11 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Fire.Rank" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc11,{output$hotable11 = renderHotable({calc11(hot.to.df(input$hotable11))})})
  observeEvent(input$up11,{upload(input$hotable11,11)})
  
  #tab12
  output$hotable12 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Monopoly.Win" = rep(0,9),
      "Cluedo.Win" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc12,{output$hotable12 = renderHotable({calc12(hot.to.df(input$hotable12))})})
  observeEvent(input$up12,{upload(input$hotable12,12)})
  
  #tab13
  output$hotable13 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Pong.Rank" = rep(0,9),
      "Champion" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc13,{output$hotable13 = renderHotable({calc13(hot.to.df(input$hotable13))})})
  observeEvent(input$up13,{upload(input$hotable13,13)})
  
  #tab14
  output$hotable14 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Chess.Rank" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc14,{output$hotable14 = renderHotable({calc14(hot.to.df(input$hotable14))})})
  observeEvent(input$up14,{upload(input$hotable14,14)})
  
  #tab15
  output$hotable15 <- renderHotable({
    data.frame(
      "Participant" = leaderBoard$Participant, 
      "Final.Rank" = rep(0,9),
      "Bonus.Points" = rep(0,9),
      "Score" = rep(0,9)
    )
  }, readOnly = FALSE)
  observeEvent(input$calc15,{output$hotable15 = renderHotable({calc15(hot.to.df(input$hotable15))})})
  observeEvent(input$up15,{upload(input$hotable15,15)})
  
  output$matrix <- renderUI({
    M <- data.frame("Rounds_Completed" = rounds,
                    "Current_Score"= leaderBoard$Score,
                    "Win_Probability" = odds,
                    "Best_Man_Odds" = odds.real)
    
    rownames(M) <- leaderBoard$Participant
    
    M <- print(xtable(M, align=rep("l", ncol(M)+1)), 
               floating=FALSE, tabular.environment="array", comment=FALSE, print.results=FALSE)
    html <- paste0("$$", M, "$$")
    list(
      withMathJax(HTML(html))
    )
  })
  
#   lapply(1:10, function(i){
#     #output[[paste0("img",i)]] <- renderImage({
#      # list(src = paste0("www/",leaderBoard[i,1],".png"),contentType = 'image/png',align = "center",width = 150,height = 150)}, deleteFile = FALSE)
#     output[[paste0("lead",i)]] <- renderText({leaderBoard[i,1]})
#     output[[paste0("points",i)]] <- renderText({leaderBoard[i,2]})
#     output[[paste0("odds",i)]] <- renderText({odds[i]})
#     
#   })
  
}