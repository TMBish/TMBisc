simulate = function(round, board) {
  
  LB = data.frame("Names" = c("Brass",
                              "Burgin",
                              "Dower",
                              "Henri",
                              "Kirkpatrick",
                              "Massingham",
                              "McGrath",
                              "Potter",
                              "Powell"),
                  "Points" = board)
  
  wins = rep(0,9)
  
  for (j in 1:1000) {
    
    vec = LB$Points
    
    for (i in round:15) {
      vec = vec + roundSimulate(i)
    }
    
    wins[which.max(vec)] = wins[which.max(vec)]+1
  }
  
  return(wins / 1000)
  
}

polyRank = function(board,points) {
  power = (10-board)^2
  scaled = power / (sum(power)/points)
  return(scaled)
}


roundSimulate = function(round) {
  
  if (round == 1) {
    
    rankPoints = polyRank(sample(1:10,9),150)
    bonus = round(runif(1,1,10),0)
    rankPoints[bonus] = rankPoints[bonus] + 20 
    return(rankPoints)
    
  } else if (round == 2) {
    
    rankPoints = polyRank(sample(1:10,9),50)
    bonus = round(runif(1,1,9),0)
    rankPoints[bonus] = rankPoints[bonus] + 25
    bonus = sample(1:9,5)
    rankPoints[bonus] = rankPoints[bonus] + 10
    return(rankPoints)
    
    
  } else if (round == 3) {
    
    rankPoints = polyRank(sample(1:9,9),100)
    bonus = sample(1:9,2)
    rankPoints[bonus] = rankPoints[bonus] + 10
    return(rankPoints)
    
  } else if (round == 4) {
    
    rankPoints = polyRank(sample(1:10,9),80)
    return(rankPoints)
    
  } else if (round == 5) {
    
    rankPoints = rep(0,9)
    bonus = sample(1:9,5)
    rankPoints[bonus] = rankPoints[bonus] + 10
    #rankPoints = rankPoints + round(sample(1,100,9,replace = TRUE)/10,0)
    return(rankPoints)
    
  } else if (round == 6) {
    
    rankPoints = rep(0,9)
    bonus = sample(1:9,5)
    rankPoints[bonus] = rankPoints[bonus] + 15
    return(rankPoints)
    
  } else if (round == 7) {
    
    rankPoints = polyRank(sample(1:9,9),100)
    bonus = sample(1:9,1)
    rankPoints[bonus] = rankPoints[bonus] + 20
    return(rankPoints)
    
  } else if (round == 8) {
    
    rankPoints = rep(0,9)
    bonus = sample(1:9,3)
    rankPoints[bonus[1]] = rankPoints[bonus[1]] + 40
    rankPoints[bonus[2]] = rankPoints[bonus[2]] + 25
    rankPoints[bonus[3]] = rankPoints[bonus[3]] + 15
    return(rankPoints)
    
  } else if (round == 9) {
    
    rankPoints = polyRank(sample(1:9,9),80)
    bonus = sample(1:9,2)
    rankPoints[bonus] = rankPoints[bonus] + 10
    return(rankPoints)
    
  } else if (round == 10) {
    
    rankPoints = polyRank(sample(1:9,9),80)
    bonus = sample(1:9,1)
    rankPoints[bonus] = rankPoints[bonus] + 10
    return(rankPoints)
    
  } else if (round == 11) {
    
    rankPoints = polyRank(sample(1:9,9),100)
    bonus = sample(1:9,1)
    rankPoints[bonus] = rankPoints[bonus] + 10
    return(rankPoints)
    
  } else if (round == 12) {
    
    rankPoints = rep(0,9)
    bonus = sample(1:9,2)
    rankPoints[bonus] = rankPoints[bonus] + 20
    bonus = sample(1:9,2)
    rankPoints[bonus] = rankPoints[bonus] + 20
    return(rankPoints)
    
  } else if (round == 13) {
    
    rankPoints = polyRank(sample(1:9,9),80)
    bonus = sample(1:9,1)
    rankPoints[bonus] = rankPoints[bonus] + 20
    return(rankPoints)
    
  } else if (round == 14) {
    
    rankPoints = polyRank(sample(1:9,9),120)
    return(rankPoints)
    
  } else {
    
    rankPoints = polyRank(sample(1:9,9),200)
    bonus = sample(1:9,1)
    rankPoints[bonus] = rankPoints[bonus] + 30
    return(rankPoints)
    
  }
  
}