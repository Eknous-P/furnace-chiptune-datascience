ggplot(
  data = chip_usage_data,
  aes(
    x = date,
    y = count,
    color = chip
  )
)+
geom_path(
  alpha=.9
) -> plot_perChip

ggplotly(
  p = plot_perChip,
  dynamic_axes = TRUE,
  tooltip = "text"
)%>%
  # js function to open the video when clicked on it
  onRender( # TODO: fix
    "
  function (el, x, data) {
    el.on('plotly_click', function(d) {
      console.log(d)
      console.log(data)
    })
  }
  ", data = data_frame (
    id = data_topViews$vid_id
  )
  )-> plot_perChip
