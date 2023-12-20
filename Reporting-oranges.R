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

###################################
##### package and data ####
###################################
library(dplyr)
library(quarto)
library(ggplot2)
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
orange_mean <- Orange %>%
  group_by(Tree) %>%
  summarise_at(vars(c(age, circumference)), list(mean = mean))

###################################
##### render ####
###################################
# save image
rm(list = ls()[grep(pattern = "df.raw", ls(), invert = F)])
save.image("./wd.RData")

# render quarto
quarto_render("report.qmd", output_format = "html")
# shell.exec(file.path("report.html", fsep = "\\"))