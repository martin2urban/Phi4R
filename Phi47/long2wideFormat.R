## Script to clean up phi46.xlsx and save as parsable File
##  followed by stats analysis   2018-09-30
##
#--Environment----
#library(magrittr)    #dplyr automatically loads magrittr
#library(plyr)
#library(reshape)

library(dplyr)
library(data.table)
library(tidyr)
library(readxl) #part of tidyverse package, there is no write function yet. Thus us openxlsx to write to excel.
library(here)
#setwd("H:/GoogleDrive/VIMdb/Projects/PHIbase/")
#--MAIN--------------------------------------------------------- 
dat=read_excel(here("Phi47/dat.xlsx"), sheet= "MuReduced6")
dat_wide=dat %>% spread(key=Cols, value=Phenotype)
write.csv(dat_wide, here("Phi47/dat_wide.csv"), row.names=FALSE)

