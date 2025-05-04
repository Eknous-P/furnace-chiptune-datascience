chips <- read_csv(
  file = "chips.csv",
  comment = "#",
  show_col_types=0
)|>clean_names()

mus_chips_data <- mus_clean_data

for (i in 1:dim(chips)[1]) {
  curChip = chips$sys_name[i]
  mus_chips_data <-
  mus_chips_data|>
  mutate(
    "has_{curChip}" := Reduce("|", list(
      stri_detect_regex(vid_title, curChip),
      stri_detect_regex(vid_title, chips$alt_name[i])
      # furnace explanations in the desc break this, disabling
      # stri_detect_regex(vid_desc, curChip),
      # stri_detect_regex(vid_desc, chips$alt_name[i])
    ))
  )
}
