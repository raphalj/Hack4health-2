###################################
##### function ####
###################################



#### Table ####
Orange_table_kbl <- function(Data, Language){
 Data_min <- Data %>%
    group_by(Tree) %>%
    summarise_at(vars(c(age, circumference)), list(min = min))
  
  Data_max <- Data %>%
    group_by(Tree) %>%
    summarise_at(vars(c(age, circumference)), list(max = max))
  
  Data_table <- merge(Data_min, Data_max, by = "Tree")
  
  kable(Data_table, 
        col.names = c("Tree", "min age", "min circumference","max age", "max circumference"),
        align = "c", 
        caption = "Min and max age and circumference by tree group", 
        footnote = "5 trees were followed durign this study.")
  
}
