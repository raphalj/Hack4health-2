###################################
##### function ####
###################################

# to do
#| make function
#| with var as police_size
police_size <- 25
mytheme <- theme(plot.subtitle = element_text(vjust= 4, color = "#006633" , size = police_size+5),
                 plot.margin = margin(1, 1, 1, 1, "cm"),
                 legend.title = element_blank(),
                 legend.position = c(0.2, 0.8),
                 legend.background = element_rect(linewidth = 0.5, linetype = "solid", colour = "grey"),
                 legend.text=element_text(size = police_size),
                 panel.background = element_rect(fill= "white" , colour = NA),
                 axis.title.y = element_text(size = police_size + 5),
                 axis.title.x = element_text(size = police_size + 5),
                 axis.text.x = element_text(size = police_size, angle = 90),
                 axis.text.y=element_text(size = police_size),
                 panel.grid.major.y = element_line(color = "grey", linewidth = 0.75, linetype = "dashed"),
                 panel.grid.major.x = element_blank(),
                 panel.grid.minor =element_blank())