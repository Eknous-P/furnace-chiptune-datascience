# setup plot data
mus_clean_data|>
  mutate( # plot hover tooltip
    text = paste(
      "<b>Author:</b> ", vid_auth,
      "\n<b>Title:</b> ", vid_title
    )
  ) -> data_perChip

ggplot(
  data = data_perChip
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
