rm(list = ls())

PAQUETES <- c("dplyr","tidyverse","ggplot2","readxl","network3D")

for (el in PAQUETES){
  if (!require(el, character.only = TRUE)) {
    install.packages(el, repos = "https://cloud.r-project.org")
    require(el, character.only = TRUE)
  }
}

if(!require(networkD3)) install.packages("networkD3")
library(networkD3)

rm(PAQUETES, el)
# 
# oferta <- read_excel("data.xlsx",sheet="oferta")
# demanda <- read_excel("data.xlsx",sheet="demanda")
# 
# 
# # Example data
# nodes <- data.frame(name=c(pull(demanda,cuenta),"PIB",pull(oferta,Sector)))
# links <- data.frame(source=c(0,1,2,3,3,3,3,3), target=c(3,3,3,4,5,6,7,8), value=c(pull(demanda,"2022"),pull(oferta,"2022")))
# ### ojo, los numeros son index 0
# 
# 
# # Create the Sankey diagram
# sankey <- sankeyNetwork(Links = links, Nodes = nodes, Source = "source", Target = "target", Value = "value", NodeID = "name")
# print(sankey)


flujo<-read_excel("./data.xlsx",sheet="flujo")
nodes <- read_excel("./data.xlsx",sheet="list")


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

# myColors <- 'd3.scaleOrdinal().domain(["M", "W", "sources"]) .range(["#5485AB", "#BA4682", "#646363"])'
# Create the Sankey diagram
sankey <- sankeyNetwork(Links = links, 
                        Nodes = nodes, 
                        Source = "source", 
                        Target = "target", 
                        Value = "Value", 
                        NodeID = "name",
                        units = 'ME', 
                        fontSize = 10, 
                        nodeWidth = 20,
                        # colourScale =myColors,
                        sinksRight=FALSE,
                        # iterations = 0 #allows to manual order of nodes as in the nodes df
                        )
print(sankey)






# 
# 
# URL <- paste0('https://cdn.rawgit.com/christophergandrud/networkD3/',
#               'master/JSONdata/energy.json')
# 
# energy <- jsonlite::fromJSON(URL)
# 
# # Plot
# sankeyNetwork(Links = energy$links, Nodes = energy$nodes, Source = 'source',
#               Target = 'target', Value = 'value', NodeID = 'name',
#               units = 'TWh', fontSize = 12, nodeWidth = 30)
# 
# # Colour links
# energy$links$energy_type <- sub(' .*', '',
#                                 energy$nodes[energy$links$source + 1, 'name'])
# 
# sankeyNetwork(Links = energy$links, Nodes = energy$nodes, Source = 'source',
#               Target = 'target', Value = 'value', NodeID = 'name',
#               LinkGroup = 'energy_type', NodeGroup = NULL)
