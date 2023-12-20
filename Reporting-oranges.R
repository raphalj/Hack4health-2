###################################
##### aim ####
###################################
#| produce quarto html docs in three language
#| each doc needs two figures translated
#| translation are located in csv file Hack4health-2\figure_translation.csv
#| translate title, x, y axis, label legend
#| render in the present script
#| use github to collaborate on project each member developing a part of the code

.libPaths( "//sciensano.be/fs/1100_EPIVG_Employee/20231220_Hackathon/TranslationPlot/libraries" )

Table_lng <- read.csv("//sciensano.be/FS/louise.vaes/4. R/Hack4Health23/Hack4health-2/figure_translation.csv")

###################################
##### package and data ####
###################################
library(dplyr)
library(quarto)
library(ggplot2)
library(knitr)
data("Orange")

###################################
##### Figure 1 ####
###################################
Orange %>%
  ggplot(aes(x = circumference, y = age, colour = Tree)) +
  geom_point()

###################################
##### figure 2 with sciensano theme ####
###################################
#| same figure with sciensano theme

###################################
##### figure 3 ####
###################################
#| same figure produced by a function save in fct.R
#| fct with language in argument

###################################
##### Table 1 ####
###################################
Orange_min <- Orange %>%
  group_by(Tree) %>%
  summarise_at(vars(c(age, circumference)), list(min = min))

Orange_max <- Orange %>%
  group_by(Tree) %>%
  summarise_at(vars(c(age, circumference)), list(max = max))

Orange_table <- merge(Orange_min, Orange_max, by = "Tree")

kable(Orange_table, 
      col.names = c("Tree", "min age", "min circumference","max age", "max circumference"),
      align = "c", 
      caption = "Min and max age and circumference by tree group", 
      footnote = "5 trees were followed durign this study.")

###################################
##### Table function ####
###################################
Orange_table_kbl(Orange, "ENG")

###################################
##### render ####
###################################
# save image
rm(list = ls()[grep(pattern = "df.raw", ls(), invert = F)])
save.image("./wd.RData")

# render quarto
quarto_render("report.qmd", output_format = "html")
# shell.exec(file.path("report.html", fsep = "\\"))