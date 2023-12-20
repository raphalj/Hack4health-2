###################################
##### function ####
###################################

#### Language selection ####

Lng_sel <- function(Type, Var, Lng){
  Lng_sel <- Table_lng %>%
    filter(type == Type, str_detect(var, Var)) %>%
    select(all_of(Lng)) %>%
    as.vector %>%
    unlist
  return(Lng_sel)
}

#### Table ####
Orange_table_kbl <- function(Data, Table_lng, Lng){
  
  colnames <- Lng_sel("Orange_table", "col", Lng)
  
  # colnames <- Table_lng %>%
  #   filter(type == "Orange_table", str_detect(var, "col")) %>%
  #   select(Lng) %>%
  #   as.vector() %>%
  #   unlist()
  
  caption <- Lng_sel("Orange_table", "caption", Lng)

  # caption <- Table_lng %>%
  #   filter(type == "Orange_table", var == "caption") %>%
  #   select(Lng) %>%
  #   as.vector() %>%
  #   unlist()
  
  Data_min <- Data %>%
    group_by(Tree) %>%
    summarise_at(vars(c(age, circumference)), list(min = min))
  
  Data_max <- Data %>%
    group_by(Tree) %>%
    summarise_at(vars(c(age, circumference)), list(max = max))
  
  Data_table <- merge(Data_min, Data_max, by = "Tree")
  
  kable(Data_table, "pipe",
        # col.names = c("Tree", "min age", "min circumference","max age", "max circumference"),
        col.names = colnames,
        align = "c", 
        # caption = "Min and max age and circumference by tree group", 
        caption = caption, 
        label = "Orange_table")
  
}
