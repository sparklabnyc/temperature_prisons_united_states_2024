rm(list=ls())

# 0a Load Packages
library(here)

# 1a Declare directories (can add to over time)
project.folder = paste0(print(here::here()),'/')
  code.folder = paste0(project.folder, "code/")
    data.prep.code.folder = paste0(code.folder, "data_prep/")
    data.exploration.folder = paste0(code.folder, "data_exploration/")
    functions.folder = paste0(code.folder, "functions/")
    packages.folder = paste0(code.folder, "packages/")
    models.folder = paste0(code.folder, "models/")
    model.processing.folder = paste0(code.folder, "model_processing/")
  data.folder = paste0(project.folder, "data/")
    file.locations.folder = paste0(data.folder, "file_locations/")
    mortality.folder = paste0(data.folder,"mortality/")
    objects.folder = paste0(data.folder, "objects/")
  output.folder = paste0(project.folder, "output/")
  figures.folder = paste0(project.folder, "figures/")
  tables.folder = paste0(project.folder, "tables/")
  reports.folder = paste0(project.folder, "reports/")

# 1b Identify list of folder locations which have just been created above
folders.names = grep(".folder",names(.GlobalEnv),value=TRUE)

# 1c Create function to create list of folders
# note that the function will not create a folder if it already exists 
create_folders = function(name){
  ifelse(!dir.exists(get(name)), dir.create(get(name), recursive=TRUE), FALSE)
}

# 1d Create the folders named above
lapply(folders.names, create_folders)