###################################
##### function ####
###################################



#### Table ####
Orange_table_kbl <- function(Data, Table_lng, Lng){
  
  colnames <- Table_lng %>%
    filter(type == "Orange_table", var == "colnames") 
  
  caption <- Table_lng %>%
    filter(type == "Orange_table", var == "caption") 
  
  footnote <- Table_lng %>%
    filter(type == "Orange_table", var == "footnote") 
  
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
        # caption = "Min and max age and circumference by tree group", 
        caption = caption[[Lng]],
        footnote = footnote[[Lng]])
  
}
