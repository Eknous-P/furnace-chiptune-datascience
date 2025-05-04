# setup plot data
mus_clean_data|>
mutate( # plot hover tooltip
  text = paste(
    "<b>Author:</b> ", vid_auth,
    "\n<b>Title:</b> ", vid_title,
    "\n", vid_stat_view, "views"
  )
)|>
arrange(vid_stat_view)|>
tail(20) -> data_topViews

ggplot(
  data = data_topViews,
  aes(
    y = factor(vid_title, level = vid_title),
    x = vid_stat_view,
    fill = vid_auth,
    text = text,
    id = vid_id,
  )
)+
scale_y_discrete( # trim titles to 20 chars
  labels = as_function(~ strtrim(.,20))
)+
geom_col(
  aes(
    group = vid_stat_view
  )
)+
labs(
  title = NULL,
  y = "Video Title",
  x = "Video Views",
  fill = "Video Author (channel)",
) -> plot_topViews

ggplotly(
  p = plot_topViews,
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
)-> plot_topViews
  