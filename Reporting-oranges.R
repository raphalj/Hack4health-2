###################################
##### aim ####
###################################
#| produce quarto html docs in three language
#| each doc needs two figures translated
#| translation are located in csv file Hack4health-2\figure_translation.csv
#| translate title, x, y axis, label legend
#| render in the present script
#| use github to collaborate on project each member developing a part of the code

###################################
##### package and data ####
###################################
.libPaths( "//sciensano.be/fs/1100_EPIVG_Employee/20231220_Hackathon/TranslationPlot/libraries" )
# getwd()
# file.exists("figure_translation.csv")
library(dplyr)
library(quarto)
library(ggplot2)
library(knitr)
library(stringr)
data("Orange")

# load functions
source("fct.R")
Table_lng <- read.csv("figure_translation.csv", encoding = "latin1")


###################################
##### Figure 1 ####
###################################
#| save_EN, FR, NL
#| filter

# ggplot(aes(x = sampledate, y = ct, colour = target)) +
#   geom_point(size = 3, na.rm = TRUE) +
#   geom_line(size = 1.2, na.rm = TRUE) +
#   scale_y_reverse() +
#   scale_x_date(date_labels = "%Yw%W", breaks = "1 week") +
#   labs(subtitle = area, x = "", y = "Ct", colour = "")

Orange %>%
  ggplot(aes(x = circumference, y = age, colour = Tree)) +
  geom_point()

###################################
##### Table function ####
###################################
#| to do
#| col names
#| accents: ok

table_orange_FR <- Orange_table_kbl(Orange, Table_lng, "FR")
table_orange_NL <- Orange_table_kbl(Orange, Table_lng, "NL")
table_orange_EN <- Orange_table_kbl(Orange, Table_lng, "EN")

###################################
##### render ####
###################################
#| quarto

# save image
# rm(list = ls()[grep(pattern = "df.raw", ls(), invert = F)])
# save.image("./wd.RData")
# 
# # render quarto
# quarto_render("report.qmd", output_format = "html")
# shell.exec(file.path("report.html", fsep = "\\"))