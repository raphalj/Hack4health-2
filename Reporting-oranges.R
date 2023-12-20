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
# webshot::install_phantomjs()
library(dplyr)
library(quarto)
library(ggplot2)
library(knitr)
library(stringr)
library(kableExtra)
library(readr)
data("Orange")

# load functions
source("fct.R")
Table_lng <- read.csv("figure_translation.csv", encoding = "latin1")


###################################
##### Figure 1 ####
###################################
#| save_EN, FR, NL
#| filter

for (Lng in c("EN", "FR", "NL")) {
  
  title_i <- Lng_sel("Orange_plot", "title", Lng)
  xaxis_i <- Lng_sel("Orange_plot", "xaxis", Lng)
  yaxis_i <- Lng_sel("Orange_plot", "yaxis", Lng)
  category_i <- Lng_sel("Orange_plot", "color", Lng)
  
  # title_i
  # xaxis_i
  # yaxis_i
  # category_i
  
  p1 <- Orange %>%
    filter(circumference<150) %>%
    ggplot(aes(x = circumference, y = age, colour = Tree)) +
    geom_point(size = 3, na.rm = TRUE) +
    # geom_line(size = 1.2, na.rm = TRUE) +
    labs(
      # subtitle = title,
      x = xaxis_i, y = yaxis_i, colour = category_i)
  
  ggsave(file = paste0("./plots/Plot_Circum150_age_",Lng,".png"), p1)
  
}

###################################
##### Table function ####
###################################
#| to do
#| col names
#| accents: ok

table_orange_FR <- Orange_table_kbl(Orange, Table_lng, "FR")
# save_kable(table_orange_FR, "FR/table_orange.txt")
table_orange_NL <- Orange_table_kbl(Orange, Table_lng, "NL")
# save_kable(table_orange_NL, "NL/table_orange.txt")
table_orange_EN <- Orange_table_kbl(Orange, Table_lng, "EN")
# save_kable(table_orange_EN, "EN/table_orange.png")

###################################
##### render ####
###################################
#| quarto

# save image
# rm(list = ls()[grep(pattern = "df.raw", ls(), invert = F)])
save.image("./wd.RData")

# render quarto
for(i in c("EN", "FR", "NL")){
  quarto_render(paste0("./quarto/Reporting-oranges_", i, ".qmd"), output_format = "docx")
}

shell.exec(file.path("quarto", paste0("Reporting-oranges_", i, ".docx"), fsep = "\\"))
