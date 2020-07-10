# library(shinydashboard)
# library(shinysky)
# library(plyr)
# options(stringsAsFactors = FALSE)
# 
# scores = read.csv("scores.csv")
# 
# leaderBoard = ddply(scores,.(Participant), summarise, "Score" = sum(Points))
# leaderBoard = leaderBoard[order(-leaderBoard$Score),]
# 
# sourceDir <- function (path, pattern = "\\.[rR]$", env = NULL, chdir = TRUE) 
# {
#   files <- sort(dir(path, pattern, full.names = TRUE))
#   lapply(files, source, chdir = chdir)
# }
# 
# sourceDir("./tabs")
# 
# 
# upload = function(hotable, id) {
#   newData = hot.to.df(hotable)
#   newData = data.frame("Participant" = newData$Participant, "ChallengeID"= rep(id,10),"Points"=newData$Score)
#   oldScores = read.csv("scores.csv")
#   updated = rbind(oldScores,newData)
#   write.csv(updated,"scores.csv", row.names = FALSE)
# }



library(shinydashboard)
library(shinysky)
library(plyr)
library(scales)
library(xtable)
options(stringsAsFactors = FALSE)

scores = read.csv("scores.csv")

leaderBoard = ddply(scores,.(Participant), summarise, "Score" = sum(Points))
leaderBoard = leaderBoard[order(-leaderBoard$Score),]

sourceDir <- function (path, pattern = "\\.[rR]$", env = NULL, chdir = TRUE) 
{
  files <- sort(dir(path, pattern, full.names = TRUE))
  lapply(files, source, chdir = chdir)
}

sourceDir("./tabs")
sourceDir("./Simulator")

odds = simulate(max(scores$ChallengeID),leaderBoard$Score)
odds.real = sapply(odds, function(x) {paste0(round(1/x,0),":1")})
odds = percent(odds)
rounds = paste0(max(scores$ChallengeID)," / 15")

upload = function(hotable, id) {
  newData = hot.to.df(hotable)
  newData = data.frame("Participant" = newData$Participant, "ChallengeID"= rep(id,9),"Points"=newData$Score)
  oldScores = read.csv("scores.csv")
  updated = rbind(oldScores,newData)
  write.csv(updated,"scores.csv", row.names = FALSE)
}

