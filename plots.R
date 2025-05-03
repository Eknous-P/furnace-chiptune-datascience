#| message: false
#| echo: false

source("cleaner.R")
library(rlang)

# PLOT UPLOAD HISTORY
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
# PLOT MOST VIEWED
mus_clean_data|>
arrange(vid_stat_view)|>
tail(20)|>
ggplot(
  aes(
    y = factor(vid_title, level = vid_title),
    x = vid_stat_view,
    fill = vid_auth
  )
)+
scale_y_discrete(
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
# PLOT MOST LIKED
mus_clean_data|>
  arrange(vid_stat_like)|>
  tail(20)|>
  ggplot(
    aes(
      y = factor(vid_title, level = vid_title),
      x = vid_stat_like,
      fill = vid_auth
    )
  )+
  scale_y_discrete(
    labels = as_function(~ strtrim(.,20))
  )+
  geom_col(
    aes(
      group = vid_stat_like
    )
  )+
  theme(
    legend.position = "bottom",
    legend.title.position = "top"
  )+
  labs(
    title = "Top 20 Most Liked Videos in the Playlist",
    y = "Video Title",
    x = "Video Likes",
    fill = "Video Author (channel)"
  )-> plot_most_liked
# PLOT LIKE/VIEW RATIO
mus_clean_data|>
  mutate(
    vid_view_like_ratio = if_else(vid_stat_like/vid_stat_view==Inf, 0, vid_stat_like/vid_stat_view)
  )|>
  arrange(vid_view_like_ratio)|>
  tail(20)|>
  ggplot(
    aes(
      y = factor(vid_title, level = vid_title),
      x = vid_view_like_ratio,
      fill = vid_auth
    )
  )+
  scale_y_discrete(
    labels = as_function(~ strtrim(.,20))
  )+
  geom_col(
    aes(
      group = vid_view_like_ratio
    )
  )+
  theme(
    legend.position = "bottom",
    legend.title.position = "top"
  )+
  labs(
    title = "Top 20 Videos with the Highest Like/View Ratio",
    y = "Video Title",
    x = "Ratio",
    fill = "Video Author (channel)"
  )-> plot_like_view_ratio

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
