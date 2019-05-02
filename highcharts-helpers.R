tmhc_line = function(.vector) {
  
  tibble(x = seq_along(.vector), y = .vector) %>%
    hchart("line", hcaes(x = x, y = y)) %>%
    hc_add_theme(hc_theme_smpl())
  
}


tmhc_scatter = function(.vector, ma = TRUE) {
  
  .cdat = 
    tibble(x = seq_along(.vector), y = .vector) %>%
    mutate(y_ma = zoo::rollmean(y, k = 3, align = "center", fill = NA))
  
  hchart(.cdat, "scatter", hcaes(x = x, y = y)) %>%
    hc_add_theme(hc_theme_smpl()) %>%
    hc_add_series(.cdat, "spline", hcaes(x = x, y = y_ma))

  
}