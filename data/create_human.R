library(plyr)
library(stringr)
library(tidyr)
library(dplyr)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd)
head(hd)

#Dataset hd (Human Development Index) has 195 observations in eight variables. 
#After rank, country and index value there variables that are used to calculate HDI-index


str(gii)
head(gii)

#Dataset gii (Gender Development Index) has 195 observations in ten variables. The logic seems to be same than in hd: there is index and variables
#that have been used to calculate index.


#################
#Renaming columns

hd <- rename(hd, replace = c("HDI.Rank"="rank", "Country"="country", "Human.Development.Index..HDI." = "hdi_index", "Life.Expectancy.at.Birth" = "life_exp",
                             "Expected.Years.of.Education" = "exp_edu_year", "Mean.Years.of.Education" = "mean_year_edu",
                             "Gross.National.Income..GNI..per.Capita" = "gni_pc", "GNI.per.Capita.Rank.Minus.HDI.Rank" = "gni_pc_min_hdi"))

gii <- rename(gii, replace = c("GII.Rank" = "rank", "Country"="country", "Gender.Inequality.Index..GII." = "gii_index",
                               "Maternal.Mortality.Ratio" = "mat_mor_ratio", "Adolescent.Birth.Rate" = "adol_birrate",
                               "Percent.Representation.in.Parliament" = "repr_parl", "Population.with.Secondary.Education..Female." = "sec_edu_fml",
                               "Population.with.Secondary.Education..Male." = "sec_edu_male", "Labour.Force.Participation.Rate..Female." = "lab_force_fml",
                               "Labour.Force.Participation.Rate..Male." = "lab_force_male"))

########
#Mutate

gii <- mutate(gii, gender_edu_ratio = sec_edu_fml / sec_edu_male) 
gii <- mutate(gii, gender_lab_ratio = lab_force_fml / lab_force_male)

##################
#Joining data sets


human <- merge(gii, hd, by.x = "country", by.y = "country")
human <- rename(human, replace = c("rank.x" = "hdi_rank", "rank.y" = "rank_gii"))

####################
#String manipulation

human$gni_pc <- str_replace(human$gni_pc, pattern=",", replace ="") %>% as.numeric

####################
#Reducing amount of variables and filter out rows with empty values
keep <- c("country", "gender_edu_ratio", "gender_lab_ratio", "life_exp", "exp_edu_year", "gni_pc", "mat_mor_ratio", "adol_birrate", "repr_parl")
human <- select(human, one_of(keep))
data.frame(human[-1], comp = complete.cases(human))
humanFilt <- filter(human,complete.cases(human))

#################################################
#Find and filter out cases that are not countries
humanFilt <-  humanFilt[ ! humanFilt$country %in% c("East Asia and the Pacific", "Europe and Central Asia", "Latin America and the Caribbean", "Sub-Saharan Africa", "South Asia", "World", "Arab States"), ]

################
#Define rownames
rownames(humanFilt) <- humanFilt$country
humanFilt <- select(humanFilt, -country)


############
#Saving file

setwd("C:/Users/Tuukka/Desktop/IODS-project/data")
write.csv(humanFilt, file="humandata.csv")