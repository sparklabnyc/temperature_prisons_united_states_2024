rm(list=ls())
#0a.Declare root directory, folder location and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'create_folder_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))

#0b.Load libraries
library(janitor)
library(MetBrewer)
library(ggpubr)
library(cowplot)
library(tidyverse)

#1a.Load and tidy data
eco_regions <- read_csv(paste0(data.folder,"state_ecoregions.csv")) %>%
  janitor::clean_names() %>% 
  mutate(broad_eco_region = case_when(
    ecoregion %in% c(8,9,10) ~ "West", 
    ecoregion %in% c(1,2,3) ~ "Northeast", 
    ecoregion %in% c(5,7) ~ "Midwest",
    ecoregion %in% c(4,6) ~ "Southeast"))

heatmap_data <- read_csv(paste0(wbgtmax.folder, "Figure_2a.csv")) %>% 
  janitor::clean_names()

#1b.Join eco region and heatmap data (from Figure 2) for regional plot
plot_data <- left_join(heatmap_data, eco_regions)

#2.Heatmap plot by broad ecoregions
plot_ecoregion_differences = function(threshold_chosen, region,legend_chosen = 0){
    p  = ggplot() +
      geom_tile(data = plot_data %>% filter(broad_eco_region == region),
      aes(x=year, y = state, fill = get(paste0('wbgt_',threshold_chosen,'_diff'))), size = 1) +
      guides(fill = guide_colorbar(direction = "horizontal", title.position="left",barwidth = 10, 
                                   barheight = 1,title.vjust = 0.8,
                                   title = "Difference in number of hot-humid days"),
             legend.text=element_text(size=15)) +
      xlab('Year') +
      ylab('State') +
      scale_fill_gradient2(low=met.brewer('Demuth')[10],mid='white',high=met.brewer('Demuth')[1],
                           na.value="white",guide = guide_legend(nrow = 1)) +
      theme_bw() + theme(text = element_text(size = 10),
                         panel.grid.major = element_blank(),axis.text.x = element_text(angle=90 , size=8, vjust=0.5),
                         plot.title = element_text(hjust = 0.5),panel.background = element_blank(),
                         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
                         panel.border = element_rect(colour = "black"),strip.background = element_blank(),
                         legend.position = 'bottom',legend.justification='center',
                         legend.background = element_rect(fill="white", size=.5, linetype="dotted"))
    
    if(legend_chosen==0){
      p = p +
        guides(fill=FALSE)
    }
    if(legend_chosen==1){
      p = p + 
        guides(fill = guide_colorbar(direction = "horizontal", title.position="left",barwidth = 10, 
                                     barheight = 1,title.vjust = 0.8,
                                     title = "Population-weighted difference in annual number of\n hot-humid days between prisons and rest of state"),legend.text=element_text(size=15))
      
    }
    return(p)}
    
eco.reg.1 <- plot_ecoregion_differences(28,"Midwest",1)
eco.reg.2 <- plot_ecoregion_differences(28,"Northeast",1)
eco.reg.3 <- plot_ecoregion_differences(28,"West",1)    
eco.reg.4 <- plot_ecoregion_differences(28,"Southeast",1)

plot_grid(eco.reg.1, eco.reg.2, eco.reg.3, eco.reg.4,
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow = 2)


jpeg(paste0(figures.folder, 'S_Figure_1.jpeg'), res = 300, height = 2000, width = 4000)
plot_grid(eco.reg.1, eco.reg.2, eco.reg.3, eco.reg.4,
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow = 2)
dev.off()

pdf(paste0(figures.folder,'S_Figure_1.pdf'),paper='a4r',width=0,height=0)
plot_grid(eco.reg.1, eco.reg.2, eco.reg.3, eco.reg.4,
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow = 2)
dev.off()