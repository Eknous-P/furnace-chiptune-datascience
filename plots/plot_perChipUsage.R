ggplot(
  data = chip_usage_data,
  aes(
    x = date,
    y = count,
    color = chip
  )
)+
geom_path(
  alpha=.9
)+
labs(
  x = "Year",
  y = "Usage Count",
  color = "Chip"
) -> plot_perChip

ggplotly(
  p = plot_perChip,
  dynamic_axes = TRUE,
  tooltip = c("color","y")
) -> plot_perChip
