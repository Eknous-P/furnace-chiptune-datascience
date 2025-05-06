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
scale_x_date(
  breaks = chip_usage_data$date,
  date_labels="%b '%y"
)+
theme(
  axis.text.x=element_text(angle=90)
)+
labs(
  x = "Month/Year",
  y = "Usage Count",
  color = "Chip"
) -> plot_perChip

ggplotly(
  p = plot_perChip,
  dynamic_axes = TRUE,
  tooltip = c("color","y")
) -> plot_perChip
