library(taskscheduleR)

taskscheduler_create(
  "TMBISC-jobs",
  rscript = "D:\\github\\TMBisc\\JOBS\\execute.R",
  schedule = "DAILY", 
  starttime = "02:00", 
  startdate = format(Sys.Date(), "%d/%m/%Y")
)