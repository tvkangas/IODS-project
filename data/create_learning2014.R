#Tuukka Kangas, 31.1.2017
#This file includes some data, I don't know yet what

#Import all needed packages
library(dplyr)

#Read data
learn_data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#With command str() all variables can be explored
str(learn_data)

#As a summary there is 183 observations in 60 variables
#There is few background variables: age and gender
# Other variables are "Y variables", questions in the survey

#Next I copied deep, surface and strategic questions from datacamp
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#After that I combined created variables to my data

deep_columns <- select(learn_data, one_of(deep_questions))
learn_data$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learn_data, one_of(surface_questions))
learn_data$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learn_data, one_of(strategic_questions))
learn_data$stra <- rowMeans(strategic_columns)

#Next I chooce only wanted variables and do new dataset
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

#Select columns I wanted
learn_analysisdata <- select(learn_data, one_of(keep_columns))

#Filter only those rows with more than zero points
learn_analysisdata <- filter(learn_analysisdata, Points > 0)

#Structure of data can be observed. 166 observations in 7 variables.
str(learn_analysisdata)

#Change column names all lower case.
colnames(learn_analysisdata)[2] <- "age"
colnames(learn_analysisdata)[3] <- "attitude"
colnames(learn_analysisdata)[7] <- "points"

#Set working directory to my IODS folder
setwd("C:/Users/Tuukka/Desktop/IODS-project/data")

#Save data as csv file
write.csv(learn_analysisdata, file="learnAnalysisdata.csv")

#Check if the writing has been done correctly

tmpdata <- read.csv("learnAnalysisdata.csv")
head(tmpdata)
str(tmpdata)

#Everything seems to be alright. The writing process has created id, but it doesn't matter