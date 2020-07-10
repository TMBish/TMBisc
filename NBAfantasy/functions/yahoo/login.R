yahoo_login <- function(league_id, username, pwd){
  #if(nchar(league_id)!=6){stop("league_id must be six characters")}
  if(!is.character(username)){stop("username must be a character string")}
  
  uastring <- "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36"
  url <- "http://basketball.fantasysports.yahoo.com/nba/"
  url <- paste0(url, league_id)
  
  session = html_session(url, httr::user_agent(uastring))  
  
  login_form = html_form(session)[[1]]
  
  filled_form  = set_values(
    myform, 
    username=username,
    passwd = pwd
  )
  
  filled_form$url = session$response$url
  
  
  session = submit_form(session, filled_form)
  
  login_form$url = url
  
  session = submit_form(session, login_form)
  
  myform = html_form(session)[[1]]
  session = submit_form(session, login_form)
  
  session = session %>% jump_to(session$response$url)
  
  myform = rvest::html_form(session)[[1]]
  
  
  
  if("code" %in% names(myform$fields)){
    code <- readline(prompt="In your Yahoo app, find and click on the Account Key icon.\nGet the 8 character code and\nenter it here: ")
  }else{
    print("Unable to login")
    return(NULL)
  }
  myform <- rvest::set_values(myform, code=code)  
  s <- suppressWarnings(rvest::submit_form(s, myform, submit="verify"))
  if(grepl("authorize\\/verify", s$url)){
    print("Wrong code entered, unable to login")
    return(NULL)
  }else{
    print("Login successful")
  }
  s <- rvest::jump_to(s, s$response$url)
  return(s)
}