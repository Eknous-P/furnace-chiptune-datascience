# setup plot data
mus_clean_data|>
  mutate( # plot hover tooltip
    text = paste(
      "<b>Author:</b> ", vid_auth,
      "\n<b>Title:</b> ", vid_title,
      "\n", vid_stat_like, "likes"
    )
  )|>
  arrange(vid_stat_like)|>
  tail(20) -> data_topLikes

ggplot(
  data = data_topLikes,
  aes(
    y = factor(vid_title, level = vid_title),
    x = vid_stat_like,
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
      group = vid_stat_like
    )
  )+
  labs(
    title = NULL,
    y = "Video Title",
    x = "Video Likes",
    fill = "Video Author (channel)",
  ) -> plot_topLikes

ggplotly(
  p = plot_topLikes,
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
    id = data_topLikes$vid_id
  )
  )-> plot_topLikes
