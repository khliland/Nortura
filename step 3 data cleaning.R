library(tidyverse)
library(expss)
rm(list = ls())
setwd("C:/Users/christian.thorjussen/Project Nortura/")
load("analysis_df_rawdata.Rda")
data <- analysis_df[order(analysis_df$id_batch, analysis_df$age),]
table(data$prod_type)
data$chicken_type <-  ifelse(data$prod_type == 4, "Processed", 
                ifelse(data$prod_type == 6, "Grill", 
                ifelse(data$prod_type == 8, "Land",
                ifelse(data$prod_type == 12, "Organic",
                ifelse(data$prod_type == 14, "Liveche",
                ifelse(data$prod_type == 17, "McDonalds",
                ifelse(data$prod_type == 21, "Hubbard",
                ifelse(data$prod_type == 22, "Kyllinggaarden",
                ifelse(data$prod_type == 29, "Unknown", NA)))))))))
                            
#####################################
###Cleaning data for Grill chicken###
#####################################
data$weight[data$weight < 1000 & data$age > 30 & data$chicken_type == "Grill"] <- NA
data$weight[data$weight < 1000 & data$age > 30 & data$chicken_type == "Processed"] <- NA
data$weight[data$weight < 750 & data$age > 25 & data$chicken_type == "McDonalds"] <- NA
data$weight[data$weight < 100 & data$age > 19 & data$chicken_type == "Kyllinggaarden"] <- NA

#Remove observations 
grill_data <- subset(data, age <= 34 & chicken_type == "Grill")
grill_data$weight[grill_data$weight >= 100 & grill_data$age == 0] <- NA
grill_data$weight[grill_data$weight <= 34 & grill_data$age == 0] <- NA

for (i in 0:34){
  grill_data$weight[grill_data$weight == 0 & grill_data$age == i]  <- NA
  mean <- mean(grill_data$weight[grill_data$age == i], na.rm = T)
  outlier <- 4*sd(grill_data$weight[grill_data$age == i], na.rm = T)
  grill_data$weight[(grill_data$weight >= (mean + outlier) | grill_data$weight <= (mean - outlier) ) & grill_data$age == i]  <- NA
}


##########################################
###Cleaning data for Processes chicken###
##########################################
proces_data <- subset(data, age <= 35 & chicken_type == "Processed")
 
proces_data$weight[proces_data$weight >= 100 & proces_data$age == 0] <- NA
proces_data$weight[proces_data$weight <= 25 & proces_data$age == 0] <- NA

for (i in 0:35){
  proces_data$weight[proces_data$weight == 0 & proces_data$age == i]  <- NA
  mean <- mean(proces_data$weight[proces_data$age == i], na.rm = T)
  outlier <- 4*sd(proces_data$weight[proces_data$age == i], na.rm = T)
  proces_data$weight[(proces_data$weight >= (mean + outlier) | proces_data$weight <= (mean - outlier) ) & proces_data$age == i]  <- NA
}

##########################################
###Cleaning data for land chicken###
##########################################
land_data <- subset(data, age <= 53 & chicken_type == "Land")

land_data$weight[land_data$weight >= 100 & land_data$age == 0] <- NA
land_data$weight[land_data$weight <= 25 & land_data$age == 0] <- NA

for (i in 0:53){
  land_data$weight[land_data$weight == 0 & land_data$age == i]  <- NA
  mean <- mean(land_data$weight[land_data$age == i], na.rm = T)
  outlier <- 4*sd(land_data$weight[land_data$age == i], na.rm = T)
  land_data$weight[(land_data$weight >= (mean + outlier) | land_data$weight <= (mean - outlier) ) & land_data$age == i]  <- NA
}

########################################
###Cleaning data for organic chicken###
########################################
organic_data <- subset(data, age <= 77 & chicken_type == "Organic")
organic_data$weight[organic_data$weight >= 100 & organic_data$age == 0] <- NA
organic_data$weight[organic_data$weight <= 25 & organic_data$age == 0] <- NA

for (i in 0:77){
  organic_data$weight[organic_data$weight == 0 & organic_data$age == i]  <- NA
  mean <- mean(organic_data$weight[organic_data$age == i], na.rm = T)
  outlier <- 4*sd(organic_data$weight[organic_data$age == i], na.rm = T)
  organic_data$weight[(organic_data$weight >= (mean + outlier) | organic_data$weight <= (mean - outlier) ) & organic_data$age == i]  <- NA
}


########################################
###Cleaning data for liveche chicken###
########################################
liveche_data <- subset(data, age <= 52 & chicken_type == "Liveche")
liveche_data$weight[liveche_data$weight >= 100 & liveche_data$age == 0] <- NA
liveche_data$weight[liveche_data$weight <= 25 & liveche_data$age == 0] <- NA

for (i in 0:52){
  liveche_data$weight[liveche_data$weight == 0 & liveche_data$age == i]  <- NA
  mean <- mean(liveche_data$weight[liveche_data$age == i], na.rm = T)
  outlier <- 4*sd(liveche_data$weight[liveche_data$age == i], na.rm = T)
  liveche_data$weight[(liveche_data$weight >= (mean + outlier) | liveche_data$weight <= (mean - outlier) ) & liveche_data$age == i]  <- NA
}

#########################################
###Cleaning data for McDonalds chicken###
#########################################
mcdonald_data <- subset(data, age <= 34 & chicken_type == "McDonalds")
mcdonald_data$weight[mcdonald_data$weight >= 100 & mcdonald_data$age == 0] <- NA
mcdonald_data$weight[mcdonald_data$weight <= 25 & mcdonald_data$age == 0] <- NA

for (i in 0:34){
  mcdonald_data$weight[mcdonald_data$weight == 0 & mcdonald_data$age == i]  <- NA
  mean <- mean(mcdonald_data$weight[mcdonald_data$age == i], na.rm = T)
  outlier <- 4*sd(mcdonald_data$weight[mcdonald_data$age == i], na.rm = T)
  mcdonald_data$weight[(mcdonald_data$weight >= (mean + outlier) | mcdonald_data$weight <= (mean - outlier) ) & mcdonald_data$age == i]  <- NA
}

#######################################
###Cleaning data for Hubbard chicken###
#######################################
hubbard_data <- subset(data, age <= 46 & chicken_type == "Hubbard")
hubbard_data$weight[hubbard_data$weight >= 100 & hubbard_data$age == 0] <- NA
hubbard_data$weight[hubbard_data$weight <= 25 & hubbard_data$age == 0] <- NA

for (i in 0:34){
  hubbard_data$weight[hubbard_data$weight == 0 & hubbard_data$age == i]  <- NA
  mean <- mean(hubbard_data$weight[hubbard_data$age == i], na.rm = T)
  outlier <- 4*sd(hubbard_data$weight[hubbard_data$age == i], na.rm = T)
  hubbard_data$weight[(hubbard_data$weight >= (mean + outlier) | hubbard_data$weight <= (mean - outlier) ) & hubbard_data$age == i]  <- NA
}

#PPM CO2 under 200 is not plausible

##############################################
###Cleaning data for Kyllinggaarden chicken###
##############################################
kyllinggaarden_data <- subset(data, age <=34 & chicken_type == "Kyllinggaarden")
kyllinggaarden_data$weight[kyllinggaarden_data$weight >= 100 & kyllinggaarden_data$age == 0] <- NA
kyllinggaarden_data$weight[kyllinggaarden_data$weight <= 25 & kyllinggaarden_data$age == 0] <- NA

for (i in 0:34){
  kyllinggaarden_data$weight[kyllinggaarden_data$weight == 0 & kyllinggaarden_data$age == i]  <- NA
  mean <- mean(kyllinggaarden_data$weight[kyllinggaarden_data$age == i], na.rm = T)
  outlier <- 4*sd(kyllinggaarden_data$weight[kyllinggaarden_data$age == i], na.rm = T)
  kyllinggaarden_data$weight[(kyllinggaarden_data$weight >= (mean + outlier) | kyllinggaarden_data$weight <= (mean - outlier) ) & kyllinggaarden_data$age == i]  <- NA
}

#Data cleaning line by line
data <- rbind(grill_data, proces_data, land_data, organic_data, liveche_data, mcdonald_data, hubbard_data, kyllinggaarden_data)

data$light_hours[data$light_hours == 2400] <- 24
data$light_hours[data$light_hours == 2224] <- 24

data$light_hours[data$light_hours == 1818] <- 18
data$light_hours[data$light_hours == 1800] <- 18

data$light_hours[data$light_hours == 1600] <- 16
data$light_hours[data$light_hours == 65] <- 16

data$light_hours[data$light_hours == 76] <- 16
data$light_hours[data$light_hours == 80] <- 24

data$light_hours[data$light_hours == 81] <- 18
data$light_hours[data$light_hours == 98] <- 24

data$light_hours[data$light_hours == 100 & data$id_batch == 34245] <- 24
data$light_hours[data$light_hours == 100] <- 16

data$light_hours[data$light_hours == 116] <- 16
data$light_hours[data$light_hours == 156] <- 16

data$light_hours[data$light_hours == 158] <- 18
data$light_hours[data$light_hours == 161] <- 16

data$light_hours[data$light_hours == 166] <- 16
data$light_hours[data$light_hours == 171] <- 17

data$light_hours[data$light_hours == 180] <- 18
data$light_hours[data$light_hours == 181] <- 18

data$light_hours[data$light_hours == 187] <- 18
data$light_hours[data$light_hours == 188] <- 18

data$light_hours[data$light_hours == 216] <- 16
data$light_hours[data$light_hours == 240] <- 24

data$light_hours[data$light_hours == 244] <- 24
data$light_hours[data$light_hours == 60] <- 16

data$light_hours[data$light_hours == 25] <- 24
data$light_hours[data$light_hours == 28] <- 18

data$light_hours[data$light_hours == 40 & data$id_batch == 77492] <- 18
data$light_hours[data$light_hours == 40 & data$id_batch == 82348] <- 16

data$light_hours[data$light_hours == 47] <- 16
data$light_hours[data$light_hours == 50 & data$id_batch == 28025] <- 18

data$light_hours[data$id_batch == 83030 & data$age > 6 & data$age < 34] <- 18
data$light_hours[data$id_batch == 83030 & data$age == 34] <- 24

data$dark_periods[data$id_batch == 83030 & data$age > 6 & data$age < 34] <- 1
data$dark_hours[data$id_batch == 83030] <- 24

data$light_hours[data$light_hours == 57] <- 16
data$light_hours[data$light_hours == 63 & data$age < 33] <- 16

data$light_hours[data$light_hours == 63] <- 24
data$light_hours[data$light_hours > 24] <- NA

data$temp_max[data$temp_max == -99.0] <- NA
data$temp_min[data$temp_min >= 80] <- NA
data$temp_max[data$temp_max >= 80] <- NA
data$humidity_min[data$humidity_min > 100] <- NA
data$humidity_max[data$humidity_max > 100] <- NA
data$humidity_min[data$humidity_min < 1] <- NA
data$humidity_max[data$humidity_max < 1] <- NA


library(janitor)
data <- data %>% 
        clean_names()

save(data,file="analysis_df_cleaned.Rda")


