rm(list = ls())

PAQUETES <- c("dplyr","tidyverse","ggplot2","readxl","network3D")

for (el in PAQUETES){
  if (!require(el, character.only = TRUE)) {
    install.packages(el)
    require(el, character.only = TRUE)
  }
}

if(!require(networkD3)) install.packages("networkD3")
library(networkD3)

rm(PAQUETES, el)



flujo<-read_excel("./data_salarios.xlsx",range="A1:C21",sheet="flujo")
nodes <- read_excel("./data_salarios.xlsx",range="A1:A22",sheet="list")

flujo_2<-read_excel("./1.data/S_1.xlsx",sheet="flujo")

flujo<-rbind(flujo,flujo_2)

source_index<-list()
ii<-1
for (element in flujo$Source) {
  indices <- which(nodes == element)
  source_index[[ii]] <- indices-1
  ii<-ii+1
}

target_index<-list()
ii<-1
for (element in flujo$target) {
  indices <- which(nodes == element)
  target_index[[ii]] <- indices-1
  ii<-ii+1
}

#create links dataframe
links<-flujo %>%
  mutate(source=as.numeric(source_index),
         target=as.numeric(target_index)
         )%>%
  select(-Source)

# myColors <- 'd3.scaleOrdinal().domain(["M", "W"]) .range(["#5485AB", "#BA4682"])'
# Create the Sankey diagram
sankey <- sankeyNetwork(Links = links, 
                        Nodes = nodes, 
                        Source = "source", 
                        Target = "target", 
                        Value = "Value", 
                        NodeID = "name",
                        units = 'Milliones de Euros', 
                        fontSize = 12, 
                        nodeWidth = 20,
                        colourScale ="d3.scaleOrdinal(d3.schemeCategory20)",
                        sinksRight=F,
                        # iterations = 0 #allows to manual order of nodes as in the nodes df
                        )
print(sankey)


