rm(list=ls())
#0a.Declare root directory, folder location and load essential stuff
project.folder = paste0(print(here::here()),'/')
source(paste0(project.folder,'create_folder_structure.R'))
source(paste0(functions.folder,'script_initiate.R'))


#0b.Load libraries
library(data.table)
library(maptools)
library(mapproj)
library(rgeos)
library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(raster)
library(sp)
library(plyr)
library(graticule)
library(zoo)
library(purrr)
library(cowplot)

#1a.Load data 
dat.wbgt.summarised.regression = readRDS(paste0(wbgt.folder,'weighted_area_raster_prison_wbgtmax_daily_',start_year_wbgt,'_',end_year_wbgt,'_regression_analysis.rds'))

us.main = readOGR(dsn=paste0(project.folder,"data/shapefiles/Prison_Boundaries/"),
                  layer="Prison_Boundaries_Edited")
us.main = spTransform(us.main, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))

dat.wbgt.summarised = readRDS(paste0(wbgt.folder,'weighted_area_raster_prison_wbgtmax_daily_',start_year_wbgt,'_',end_year_wbgt,'_over_time.rds'))
dat.wbgt.summarised.merged.weighted.state = readRDS(paste0(wbgt.folder,'weighted_area_raster_state_wbgtmax_daily_',start_year_wbgt,'_',end_year_wbgt,'_over_time.rds'))

#1b.Fortify to prepare for plotting in ggplot
map = fortify(us.main)
us.main@data$id = rownames(us.main@data) # extract data from shapefile
shapefile.data = us.main@data

#1c.Fix the weird Alabama mistake
shapefile.data = shapefile.data %>%
  dplyr::mutate(STATEFP=case_when(STATEFP=='10' & STATE=='AL'~ '01',
                                  TRUE ~ STATEFP))

USA.df = merge(map, shapefile.data, by='id') # merge selected data to map_create dataframe for colouring of ggplot
USA.df$prison_id = as.integer(as.character(USA.df$FID))

#2.Merge prison over time file with shapefile data then summarise by state and year weighted by prison population
dat.wbgt.summarised.merged.weighted.prison = left_join(dat.wbgt.summarised,shapefile.data, by=c('prison_id'='FID')) %>% 
  dplyr::filter(STATUS=='OPEN') %>% 
  dplyr::filter(POPULATION > 0) %>%
  dplyr::group_by(STATE,STATEFP,year, TYPE) %>%
  dplyr::summarise(wbgt_26 = weighted.mean(wbgt_26,POPULATION),
                   wbgt_28 = weighted.mean(wbgt_28,POPULATION),
                   wbgt_30 = weighted.mean(wbgt_30,POPULATION),
                   wbgt_35 = weighted.mean(wbgt_35,POPULATION)) 

STATES = dat.wbgt.summarised.merged.weighted.prison %>% pull(STATE) %>% unique()

dat.wbgt.summarised.merged.weighted.prison.national = left_join(dat.wbgt.summarised,shapefile.data, by=c('prison_id'='FID')) %>% 
  dplyr::filter(STATUS=='OPEN') %>% 
  dplyr::filter(POPULATION > 0) %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(wbgt_26 = weighted.mean(wbgt_26,POPULATION),
                   wbgt_28 = weighted.mean(wbgt_28,POPULATION),
                   wbgt_30 = weighted.mean(wbgt_30,POPULATION),
                   wbgt_35 = weighted.mean(wbgt_35,POPULATION)) %>%
  dplyr::mutate(STATE='USA',STATEFP='99') %>%
  dplyr::relocate(STATE) %>%
  dplyr::relocate(STATEFP)

dat.wbgt.summarised.merged.weighted.prison = 
  rbind(dat.wbgt.summarised.merged.weighted.prison,dat.wbgt.summarised.merged.weighted.prison.national) %>%
  mutate(STATE=factor(STATE, levels=rev(c('USA',STATES))))

## Merge prison vs. state to compare
dat.wbgt.summarised.merged.weighted.prison = dat.wbgt.summarised.merged.weighted.prison %>%
  dplyr::rename(wbgt_26_prison=wbgt_26,wbgt_28_prison=wbgt_28,wbgt_30_prison=wbgt_30,wbgt_35_prison=wbgt_35) %>%
  dplyr::rename(state=STATEFP)

dat.wbgt.summarised.merged.weighted.state = dat.wbgt.summarised.merged.weighted.state %>%
  dplyr::rename(wbgt_26_state=wbgt_26,wbgt_28_state=wbgt_28,wbgt_30_state=wbgt_30,wbgt_35_state=wbgt_35)

dat.wbgt.summarised.merged.weighted.prison.state = left_join(dat.wbgt.summarised.merged.weighted.prison,
                                                             dat.wbgt.summarised.merged.weighted.state,
                                                             by=c('state','year')) %>%
  dplyr::mutate(wbgt_26_diff = wbgt_26_prison - wbgt_26_state,
                wbgt_28_diff = wbgt_28_prison - wbgt_28_state,
                wbgt_30_diff = wbgt_30_prison - wbgt_30_state,
                wbgt_35_diff = wbgt_35_prison - wbgt_35_state) %>% 
  filter(!TYPE %in% c("NOT AVAILABLE")) %>% 
  filter(!is.na(TYPE)) %>% 
  mutate(TYPE = case_when(
    TYPE == "COUNTY" ~ "County",
    TYPE == "FEDERAL" ~ 'Federal',
    TYPE == "LOCAL" ~ 'Local',
    TYPE == "MULTI" ~ 'Multiple types',
    TYPE == "STATE" ~ 'State'
  ))

plot_state_type_year_difference = function(threshold_chosen,legend_chosen=0){
  p = ggplot() +
    geom_tile(data=dat.wbgt.summarised.merged.weighted.prison.state,
              aes(x=year,y=STATE,fill=get(paste0('wbgt_',threshold_chosen,'_diff'))),size=1) +
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
                       legend.background = element_rect(fill="white", size=.5, linetype="dotted")) + 
    facet_grid(~TYPE)
  
  if(legend_chosen==0){
    p = p +
      guides(fill=FALSE)
  }
  if(legend_chosen==1){
    p = p + 
      guides(fill = guide_colorbar(direction = "horizontal", title.position="left",barwidth = 10, 
                                   barheight = 1,title.vjust = 0.8,
                                   title = "Population-weighted difference in annual number of\n hot-humid days between carceral facilities and rest of state"),legend.text=element_text(size=15))
  }
  
  return(p)
}

plot.heatmap.legend = cowplot::get_legend(plot_state_type_year_difference(28,1))
plot.state.year.diff.28 = plot_state_type_year_difference(28,1)
plot.state.year.diff.28

jpeg(paste0(figures.folder, 'S_Figure_2.jpeg'), res = 300, height = 2000, width = 4000)
plot.state.year.diff.28
dev.off()

pdf(paste0(figures.folder,'S_Figure_2.pdf'),paper='a4r',width=0,height=0)
plot.state.year.diff.28
dev.off()