hc_theme_tmbish = function() {
  
  base_font = "Lato"
  # base_font = "Josefin Slab"
  header_font = "Arvo"
  
  # Headers
  axis_title_style = list(fontFamily = header_font, fontWeight = "bold", color = "#011627")
  
  gridLineCol = "rgba(122, 122, 122, 0.25)"
  
  out = 
    hc_theme(
      chart = list(
        backgroundColor = "#FDFFFC",
        style = list(
          fontFamily = base_font
        )
        #, shadow = TRUE
      ),
      colors = list("#FF9F1C", "#2EC4B6", "#FE5F55", "#C1E1F1", "#5FEF9B", "#4C6085", "#824F95", "#1789FC", "#FFE066", "#50514F"),
      title = list(
        style = list(fontFamily = header_font, fontWeight = "bold", color = "#011627", fontSize = "2em"),
        align = "left"
      ),
      xAxis = list(
        lineWidth = 1, lineColor = "#011627",
        gridLineWidth = 0.75, gridLineColor = gridLineCol, gridLineDashStyle = "LongDash",
        tickWidth = 0,
        title = list(style = axis_title_style)
      ),
      yAxis = list(
        lineWidth = 1, lineColor = "#011627",
        gridLineWidth = 0.75, gridLineColor = gridLineCol, gridLineDashStyle = "LongDash",
        minorGridLineWidth = 0, minorGridLineColor = gridLineCol,
        # tickColor = "#011627",tickLength = 10,
        # minorTickLength = 5, minorTickWidth = 1,
        tickWidth = 0,
        title = list(style = axis_title_style)
      ),
      subtitle = list(
        style = list(fontStyle = "italic", color ="#414141", size = "1.3em"), 
        align = "left"
      ),
      tooltip = list(
        shape = "square",
        valueDecimals = 2,
        backgroundColor = "#FFF",
        valueDecimals = 2,
        headerFormat = ""
        # footerFormat = "<span style = 'background-color: {point.color}; height = 4px; width = 100%;'> </span>"
        # formatter = JS("function() {
        #                series = this.series.name;
        #                x_var = this.series.x;
        #                x_val = this.x;
        #                y_var = this.y;
        #                y_val = this.y
        #                colour = this.y;
        #                
        #                string = '<b>' + series + '</b> <br> ' + this.series.xAxis.categories ;
        #                return(string) 
        #                }")
      ),
      plotOptions = list(
        line = list(marker = list(symbol = "circle", lineWidth = 2, radius = 5)),
        spline = list(marker = list(symbol = "circle", lineWidth = 2, radius = 5)),
        column = list(dataLabels = list(backgroundColor = "#FFF"), borderRadius = 3, borderWidth = 0),
        area = list(fillOpacity = 0.2)
      ),
      legend = list(
        align = "right",
        layout = "vertical",
        backgroundColor = "#FFF",
        shadow = TRUE,
        title = "Legend",
        verticalAlign = "middle"
      ),
      credits = list(
        href = "https://github.com/TMBish/lab_posts/blob/master/highcharts_theme.R",
        text = "TMBish highcharts theme"
      )
    )
}
