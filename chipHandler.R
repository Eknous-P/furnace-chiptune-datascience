chips <- read_csv(
  file = "chips.csv",
  comment = "#",
  show_col_types=0
)|>clean_names()

mus_chips_data <- mus_clean_data

# get whether chip used
for (i in 1:dim(chips)[1]) {
  curChip = chips$sys_name[i]
  mus_chips_data <-
  mus_chips_data|>
  mutate(
    "has_{curChip}" := replace_na(Reduce("|", list(
      stri_detect_regex(vid_title, curChip),
      stri_detect_regex(vid_title, chips$alt_name[i])
      # furnace explanations in the desc break this, disabling
      # stri_detect_regex(vid_desc, curChip),
      # stri_detect_regex(vid_desc, chips$alt_name[i])
    )),0)
  )
}


# restructure data to:
#  ts| count
# ---+-------
#    |  
# ---|-------
# per chip

chip_usage_data <- tibble()
mus_chips_data_permonth <- mus_chips_data|>
group_by(vid_uploaddate = floor_date(vid_uploaddate, "2 months"))|>
summarize(across(starts_with("has_"),sum))

for (i in 1:dim(chips)[1]) {
  curChip = chips$sys_name[i]
  chip_usage_data <- bind_rows(
    chip_usage_data,
    tibble(
      chip = curChip,
      date = mus_chips_data_permonth$vid_uploaddate,
      count = mus_chips_data_permonth[[i+1]]
    ))
}

