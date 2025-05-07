mus_clean_data|>
group_by(vid_uploaddate = floor_date(vid_uploaddate, "1 month")) -> mus_monthly_data
ggplot(
  data = mus_monthly_data,
  aes(
    x = vid_uploaddate,
  )
)+
  geom_bar()+
  scale_x_date(
    breaks = mus_monthly_data$vid_uploaddate,
    date_labels="%b '%y"
  )+
  theme(
    axis.text.x=element_text(angle=90)
  )+
  labs(
    x = "Month/Year",
    y = "Videos"
  ) -> plot_monthlyVideos

ggplotly(
  p = plot_monthlyVideos,
  dynamic_axes = TRUE,
  tooltip = c("y")
) -> plot_monthlyVideos
