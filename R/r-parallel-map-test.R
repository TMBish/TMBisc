library(furrr)
library(tidyverse)
library(progressr)

plan(multisession, workers = 20)

x <- replicate(n = 100, runif(20), simplify = FALSE)

with_progress({
  p <- progressor(steps = length(x))
  
  result <- future_map(x, ~{
    p()
    Sys.sleep(.2)
    sum(.x)
  })
})
