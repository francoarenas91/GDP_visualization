rm(list = ls())

PAQUETES <- c("dplyr","tidyverse","ggplot2","readxl","ggforce","ggsankey")

for (el in PAQUETES){
  if (!require(el, character.only = TRUE)) {
    install.packages(el, repos = "https://cloud.r-project.org")
    require(el, character.only = TRUE)
  }
}


rm(PAQUETES, el)

oferta <- read_excel("data.xlsx",sheet="oferta")
demanda <- read_excel("data.xlsx",sheet="demanda")


# Your data
data <- data.frame(
  x = c(1,1,2,2,3,3),
  node = c("Consumption", "Investment", "GDP","GDP","wages","EBE"),
  next_x = c(2,2,3,3,NA,1),
  next_node = c("GDP", "GDP","wages","EBE",NA,"consumption"),
  Flow = c(40, 60, 20,80,20,80)
)

# Creating the Sankey plot
ggplot(data, aes(x = x, 
               next_x = next_x, 
               node = node, 
               next_node = next_node,
               value=Flow,
               fill = factor(node),
               label=node)) +
  geom_sankey(flow.alpha = 0.75, node.color = 1) +
  scale_fill_viridis_d() +
  geom_sankey_label() +
  theme_sankey(base_size = 10) +
  theme(legend.position = "none")


