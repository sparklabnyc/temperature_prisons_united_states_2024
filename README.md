# Hazardous heat exposure among incarcerated people in the United States

Cascade Tuholske, Victoria D. Lynch, Raenita Spriggs, Yoonjung Ahn, Colin Raymond, Anne E. Nigra, Robbie M. Parks

## Introduction

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

## Other stuff

note: please run create_folder_structure.R first to create folders which may not be there when first loaded.

note: to run an R Markdown file from command line, run\
Rscript -e "rmarkdown::render('SCRIPT_NAME.Rmd')"
