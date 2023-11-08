hc_theme_tmbish = function() {
  
  base_font = "Lato"
  header_font = "Arvo"
  
  # Headers
  axis_title_style = list(fontFamily = header_font, fontWeight = "bold", color = "#011627")
  gridLineCol = "rgba(122, 122, 122, 0.25)"
  
  out = 
    hc_theme(
      chart = list(
        backgroundColor = "#FFF",
        style = list(
          fontFamily = base_font
        )
      ),
      colors = list("#e76f51", "#f4a261", "#e9c46a", "#2a9d8f", "#264653", "#219ebc", "#8ecae6", "#ff70a6"),
      #list("#F24333", "#2EC4B6", "#F9DB6D", "#083D77", "#8D3B72", "#004FFF", "#fb8500"),
      title = list(
        style = list(fontFamily = header_font, fontWeight = "bold", color = "#011627", fontSize = "1.5em"),
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
        valueDecimals = 2
      ),
      plotOptions = list(
        line = list(marker = list(symbol = "circle", lineWidth = 2, radius = 5)),
        spline = list(marker = list(symbol = "circle", lineWidth = 2, radius = 5)),
        column = list(dataLabels = list(backgroundColor = "#FFF"), borderRadius = 2, borderWidth = 0),
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
