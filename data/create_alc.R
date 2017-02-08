#Tuukka Kangas, 8.2.2017
#This script is for joining to data set together. Data files are from https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

#Import all needed packages
library(dplyr)

#Read the data tables

setwd("C:/Users/Tuukka/Desktop/IODS-project/data")
student_mat <- read.csv("student-mat.csv", sep=";",header=TRUE)
student_por <- read.csv("student-por.csv", sep=";",header=TRUE)

#Exploring datasets

str(student_mat)
dim(student_mat)
head(student_mat)

str(student_por)
dim(student_por)
head(student_por)


#Both have 33 variables. Stundet_mat has 395 and student_por 649 observations. There is some background variables like sex, age, family size and so on. Then there are
#multiple questions like health status, alcohol consuption and is responder taking some extra-curricular activities.

#Next task is to merge two data sets. The parameters that is used in merge process can be seen on function merge().

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

student_mergedTemp <- inner_join(student_mat, student_por, by = join_by, suffix = c(".math", ".por"))

print(nrow(student_mergedTemp)) 
str(student_mergedTemp)
dim(student_mergedTemp)
head(student_mergedTemp)
glimpse(student_mergedTemp)

#Now we have one big data set that have 53 variables with 382 observations, but there is some duplicate variables.

#The next step is to remove duplicates.

#First select only those columns that was used in the merging process. Then take those columns that weren't merged.

student_merged <- select(student_mergedTemp, one_of(join_by))
notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]

#Now we have to go through all not joined columns. If there is two same columns with numerical values we take the mean of those two columns.
#If not, we take the first value.

for(column_name in notjoined_columns) {
  two_columns <- select(student_mergedTemp, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]

  if(is.numeric(first_column)) {
    student_merged[column_name] <- round(rowMeans(two_columns))
  } else { 
    student_merged[column_name] <- first_column
  }
}

glimpse(student_merged)

#After the duplication removal we have data set that has 33 variables.

#Create a new variable from variables Dalc (workday alcohol consumption) and Walc (weekend alcohol consumption) by taking mean of those two

student_merged <- mutate(student_merged, alc_use = (student_merged$Dalc + student_merged$Walc) / 2)

#Create a new boolean variable high_use. If the alc_use is greater than 2 then high_use is true. Else it's false.

student_merged <- mutate(student_merged, high_use = alc_use > 2)

glimpse(student_merged)

#Now there is 382 observations in 35 variables. Everything seems to be alright.

#Save the modified data set. 

write.csv(student_merged, file="stundentAlcoholData.csv")
