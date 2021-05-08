# README

**This folder contains the files for Ian Nel's final project for the Programming with Data course.**

## Project Title: The Jingle-Jangle of Distress Tolerance and Resilience. 

### Project Description 

The present study seeks to empirically evaluate the discriminant validity of distress tolerance and resilience measures using structural equation modeling. 

## Folders

The following sections will describe the structure and content of the folders herein.

### Data 

The "data"" folder contains two datasets. These datasets contain (synthetic) demographic information, as well as multiple measures of distress tolerance, resilience, and psychopathology. The first ("DT-Res_synthetic.csv") is an archival dataset from the DEXTER (Dynamics of EXTERnalizing) Lab at USF that has been synthesized to protect confidentiality (see "Synthesizing_Data.Rmd" for germinal code). The second dataset ("DT-Res_synthetic_clean.csv") has been cleaned using the code contained in the "Final Project Code.Rmd". 

### Code 

The code folder contains two important files. The "Synthesizing_Data.Rmd" file contains the code that was used to synthesize the data for this study. Data were synthesized using the ```synthpop``` package in R in order to protect confidential data. The "Final Project Code.Rmd" contains code for inputting, wrangling, analyzing, visualizing, and outputting data.

## Doc

The doc folder contains a document ("Write-Up.Rmd) that describes the nature of the dataset, the research question, the process used to wrangle the data, and the substantive conclusions drawn.

### Output 

The output folder contains tables and figures that were generated from the code in the code folder. 