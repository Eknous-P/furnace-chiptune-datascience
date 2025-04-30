library(tidyverse)
library(readr)
library(janitor)

mus_initial_data <- read_delim(
  "./data.csv",
  delim="/",
  show_col_types = FALSE
)|>
  clean_names()

mus_clean_data <- mus_initial_data|>
  mutate(
    vid_uploaddate = as.Date(vid_uploaddate),
  )|>
  filter(
    as.numeric(format(vid_uploaddate, "%Y")) > 2021       # remove videos from before furnace
  )|>
  arrange(vid_uploaddate)|>                                # arrange by upload date
  mutate(n = row_number(), .before=vid_id)

# TODO: remove more videos
# maybe consult server

mus_views_high <- mus_clean_data|>
  filter(
    vid_stat_view>100000
  )
