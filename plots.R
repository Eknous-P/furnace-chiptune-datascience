source("cleaner.R")
library(rlang)

mus_clean_data|>ggplot(
  aes(
    x = vid_uploaddate,
    y = n
  )
)+
geom_point(
  alpha = .5,
  size = 1
)+
scale_x_date()-> plot_upload_hist

mus_clean_data|>
arrange(vid_stat_view)|>
tail(20)|>
ggplot(
  aes(
    x = vid_stat_view,
    y = vid_title,
    fill = vid_auth
  )
)+
scale_y_discrete(
  name = "Title",
  labels = as_function(~ strtrim(.,20))
)+
geom_col(
  aes(
    group = vid_stat_view
  )
)+
theme(
  legend.position = "bottom",
  legend.title.position = "top"
)+
labs(
  title = "Top 20 Most Viewed Videos in the Playlist",
  y = "Video Title",
  x = "Video Views",
  fill = "Video Author (channel)"
)-> plot_most_viewed


mus_views_high|>ggplot(
  aes(
    y = vid_stat_view,
    x = vid_auth
  )
)+
geom_point(
  alpha = 1,
  size = 2,
) -> plot_views_high
