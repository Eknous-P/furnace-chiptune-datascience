# plot click handler (opens a video)
plot_click_handler <- readLines("plot_click.js")|>stri_flatten(collapse="\n")

# raw playlist data
mus_initial_data <- read_delim(
  "./data.csv",
  delim="/",
  show_col_types = FALSE
)|>clean_names()

mus_blacklist <- pull(read_csv(file = "blacklist", col_names = 0), X1)

mus_clean_data <- mus_initial_data|>
  mutate(
    vid_uploaddate = as.Date(vid_uploaddate),
    vid_stat_length = seconds(period(vid_stat_length)),
    vid_desc = replace_na(vid_desc,"")
  )|>
  filter(
    vid_uploaddate > as.Date("2021-12-31") # remove videos from before furnace v0.2 released
  )|>
  filter(
    !(vid_id %in% mus_blacklist)           # remove blacklist videos
  )|>
  arrange(vid_uploaddate)|>                # arrange by upload date
  mutate(n = row_number(), .before=vid_id) # index chronologically

searchfor_title <- function (t) mus_clean_data|>filter(stri_detect_regex(vid_title, t))

# TODO: remove more videos
# maybe consult server

mus_views_high <- mus_clean_data|>
  filter(
    vid_stat_view > 100000
  )

mus_views_medium <- mus_clean_data|>
  filter(
    vid_stat_view < 100000 & vid_stat_view > 10000
  )

mus_views_verylow <- mus_clean_data|>
  filter(
    vid_stat_view < 100
  )
