
tmhc_grouped_density = function(.df, .group) {
  
  
  groups = .df %>% pull({{.group}}) %<% distinct()
  

  highchart() %>%
    hc_add_series(density(probs$place_prob)) %>%
  
  
}