# setup plot data
mus_clean_data|>
  mutate(
    vid_like_view_ratio = if_else(vid_stat_like/vid_stat_view==Inf, 0, vid_stat_like/vid_stat_view),
    text = paste( # plot hover tooltip
      "<b>Author:</b> ", vid_auth,
      "\n<b>Title:</b> ", vid_title,
      "\n", vid_stat_like, "likes, ",
      vid_stat_view, "views\n <b>Ratio:</b>",
      vid_like_view_ratio
    )
  )|>
  arrange(vid_like_view_ratio)|>
  tail(20) -> data_likeViewRatio

ggplot(
  data = data_likeViewRatio,
  aes(
    y = factor(vid_title, level = vid_title),
    x = vid_like_view_ratio,
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
      group = vid_like_view_ratio
    )
  )+
  labs(
    title = NULL,
    y = "Video Title",
    x = "Like/View Ratio",
    fill = "Video Author (channel)",
  ) -> plot_likeViewRatio

ggplotly(
  p = plot_likeViewRatio,
  dynamic_axes = TRUE,
  tooltip = "text"
)%>%
  onRender(
    plot_click_handler, data = data_frame (
    id = data_likeViewRatio$vid_id
  )
  )-> plot_likeViewRatio
