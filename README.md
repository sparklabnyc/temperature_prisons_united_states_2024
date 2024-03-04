# Hazardous heat exposure among incarcerated people in the United States

Cascade Tuholske, Victoria D. Lynch, Raenita Spriggs, Yoonjung Ahn, Colin Raymond, Anne E. Nigra, Robbie M. Parks\
Nature Sustainability 2024.


## Project description

This dataset and code is used for the paper 

Tuholske C, Lynch VD, Spriggs R, Ahn Y, Raymond C, Nigra AE, Parks RM (2024). [Hazardous heat exposure among incarcerated people in the United States](https://doi.org/10.1038/s41893-024-01293-y). _Nature Sustainability_.

## Code

### Data preparation (data_prep) list:

a_01_prepare_wbgt_prison_data - load WBGT prison data

a_02_prepare_wbgt_prison_summary_data - prepare WBGT prison summary data

a_03_prepare_wbgt_state_data - load WBGT state data

a_04_prepare_wbgt_state_summary_data - prepare WBGT state summary data

### Data exploration (data_exploration) list:

b_00_prisons_explore - Basic facts about prisons

b_01_figure_1 - Plot Figure 1

b_02_figure_2 - Plot Figure 2

b_03_facilities_numbers_for_manuscript - Calculate all values for main manuscript

b_04_supp_figure_1 - Plot Supp.Figure 1

b_05_supp_figure_2 - Plot Supp. Figure 2

b_06_supp_figure_3_and_4 - Plot Supp.Figure 3 (26°C) and Supp.Figure 4 (30°C)

b_07_supp_figure_5_and_6 - Plot Supp.Figure 5 (26°C) and Supp.Figure 6 (30°C)

## Directory structure

```md
.
├── README.md
├── code
│   ├── data_exploration
│   │   ├── b_00_prisons_explore.Rmd
│   │   ├── b_00_prisons_explore.html
│   │   ├── b_01_figure_1.Rmd
│   │   ├── b_01_figure_1.html
│   │   ├── b_01_figure_1_additional_values_for_press_release.Rmd
│   │   ├── b_01_figure_1_additional_values_for_press_release.html
│   │   ├── b_02_figure_2.Rmd
│   │   ├── b_02_figure_2.html
│   │   ├── b_03_facilities_numbers_for_manuscript.Rmd
│   │   ├── b_03_facilities_numbers_for_manuscript.html
│   │   ├── b_04_supp_figure_1.Rmd
│   │   ├── b_04_supp_figure_1.html
│   │   ├── b_05_supp_figure_2.Rmd
│   │   ├── b_05_supp_figure_2.html
│   │   ├── b_06_supp_figure_3_and_4.Rmd
│   │   ├── b_06_supp_figure_3_and_4.html
│   │   ├── b_07_supp_figure_5_and_6.Rmd
│   │   └── b_07_supp_figure_5_and_6.html
│   ├── data_prep
│   │   ├── a_01_prepare_wbgtmax_prison_data.Rmd
│   │   ├── a_01_prepare_wbgtmax_prison_data.html
│   │   ├── a_02_prepare_wbgt_prison_summary_data.Rmd
│   │   ├── a_02_prepare_wbgt_prison_summary_data.html
│   │   ├── a_03_prepare_wbgtmax_state_data.Rmd
│   │   ├── a_03_prepare_wbgtmax_state_data.html
│   │   ├── a_04_prepare_wbgt_state_summary_data.Rmd
│   │   └── a_04_prepare_wbgt_state_summary_data.html
│   ├── functions
│   │   ├── functions.R
│   │   └── script_initiate.R
│   ├── packages
│   │   └── packages_to_load.R
│   └── python
│       ├── 01_bil_to_tif.py
│       ├── 02_WBGTMax.py
│       ├── ClimFuncs.py
│       ├── README.txt
│       ├── move_files.py
│       └── notebooks
├── create_folder_structure.R
├── data
│   ├── cascade
│   │   ├── Station-ERA5-PRISM-Bernard-Corr.csv
│   │   ├── Station-ERA5-PRISM-Bernard-Corr_26.csv
│   │   ├── Station-ERA5-PRISM-Bernard-Corr_30.csv
│   │   ├── Station-ERA5-PRISM-RHmin-Corr.csv
│   │   ├── Station-ERA5-PRISM-RHmin-Corr_26.csv
│   │   ├── Station-ERA5-PRISM-RHmin-Corr_30.csv
│   │   ├── Station-ERA5-PRISM-Tmax-Corr.csv
│   │   ├── Station-ERA5-PRISM-Tmax-Corr_26.csv
│   │   ├── Station-ERA5-PRISM-Tmax-Corr_30.csv
│   │   ├── Wunderground-Dallas-TX-June2023.csv
│   │   ├── Wunderground-Del-Rio-TX-June2023.csv
│   │   ├── Wunderground-Huntsville-TX-June2023.csv
│   │   └── mergeddat_2015-2020.csv
│   ├── fed_prisons.csv
│   ├── file_locations
│   │   └── file_locations.R
│   ├── fips_lookup
│   │   └── climate_region_lookup
│   ├── objects
│   │   └── objects.R
│   ├── population
│   │   ├── pre_1990
│   │   └── vintage_2020
│   ├── shapefiles
│   │   ├── Prison_Boundaries
│   │   └── states
│   ├── state_ecoregions.csv
│   ├── wbgt
│   │   ├── weighted_area_raster_prison_wbgtmax_daily_1981_2021_over_time.rds
│   │   ├── weighted_area_raster_prison_wbgtmax_daily_1981_2021_regression_analysis.rds
│   │   ├── weighted_area_raster_prison_wbgtmax_daily_1982_2020_over_time.rds
│   │   ├── weighted_area_raster_prison_wbgtmax_daily_1982_2020_regression_analysis.rds
│   │   └── weighted_area_raster_state_wbgtmax_daily_1982_2020_over_time.rds
│   └── wbgt_raw
│       ├── prison
│       └── state
├── figures
│   └── wbgtmax
│       ├── Figure_1.pdf
│       ├── Figure_1a.csv
│       ├── Figure_1b.csv
│       ├── Figure_2.pdf
│       ├── Figure_2_28_alpha_sorted.pdf
│       ├── Figure_2a.csv
│       ├── Figure_2b.csv
│       ├── Figure_2c.csv
│       ├── S_Figure_1.csv
│       ├── S_Figure_1.jpeg
│       ├── S_Figure_1.pdf
│       ├── S_Figure_2.csv
│       ├── S_Figure_2.jpeg
│       ├── S_Figure_2.pdf
│       ├── S_Figure_3.pdf
│       ├── S_Figure_3a_4a.csv
│       ├── S_Figure_3b_4b.csv
│       ├── S_Figure_4.pdf
│       ├── S_Figure_5.pdf
│       ├── S_Figure_5a_6a.csv
│       ├── S_Figure_5bc_6bc.csv
│       ├── S_Figure_6.pdf
│       ├── S_Figure_7.pdf
│       ├── S_Figure_8.pdf
│       └── research_brief_figure.pdf
├── output
├── tables
└── temperature_prisons_united_states_2024.Rproj
```

## Data Availability

Data used for this analysis are available via https://github.com/sparklabnyc/temperature_prisons_united_states_2024. 

The data used in this study were created from the following datasets. 
- Daily 4-km PRISM data during 1982–2020 and HIFLD data are freely available at https://prism.oregonstate.edu/recent/ and https://hifld-geoplatform.opendata.arcgis.com, respectively.
- National Center for Health Statistics bridged-race dataset (Vintage 2020) is available during 1990–2020 (https://www.cdc.gov/nchs/nvss/bridged_race.htm) and from the US Census Bureau before 1990 (https://www.census.gov/data/tables/time-series/demo/popest/1980s-county.html). Source data are provided with this paper.
