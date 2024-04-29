#load necessary libraries
library(tidyverse)
library(lubridate)
library(janitor)
library(data.table)
library(readr)
library(psych)
library(hrbrthemes)
library(ggplot2)
# Use the conflicted package to manage conflicts
library(conflicted)

# Set dplyr::filter and dplyr::lag as the default choices
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")
#=====================
# STEP 1: COLLECT DATA
#=====================
# # Upload Divvy datasets (csv files) here
q1_2019 <- read_csv("Divvy_Trips_2019_Q1.csv")
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================

# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file
colnames(q1_2019)
colnames(q1_2020)

# Rename columns  to make them consistent with q1_2020 (as this will be the supposed going-forward table design for Divvy)

(q1_2019 <- rename(q1_2019
                   ,ride_id = trip_id
                   ,rideable_type = bikeid
                   ,started_at = start_time
                   ,ended_at = end_time
                   ,start_station_name = from_station_name
                   ,start_station_id = from_station_id
                   ,end_station_name = to_station_name
                   ,end_station_id = to_station_id
                   ,member_casual = usertype
))

# Inspect the dataframes and look for incongruencies
str(q1_2019)
str(q1_2020)

# Convert ride_id and rideable_type to character so that they can stack correctly
q1_2019 <-  mutate(q1_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 

# Stack individual quarter's data frames into one big data frame
all_trips <- bind_rows(q1_2019, q1_2020)

# Remove lat, long, birthyear, and gender fields as this data was dropped beginning in 2020
all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng, birthyear, gender,  "tripduration"))
# Save the combined files
write.csv(all_trips,file = "all_trips.csv",row.names = FALSE)

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================

# Inspect the new table that has been created
colnames(all_trips)
nrow(all_trips)
dim(all_trips)  
head(all_trips) 
str(all_trips)  
summary(all_trips)

#Count rows with "na" values
colSums(is.na(all_trips))

#Remove missing
clean_trip_final <- all_trips[complete.cases(all_trips), ]

#Remove duplicates
clean_trip_final <- distinct(clean_trip_final)
clean_trip_final <- drop_na(clean_trip_final)
clean_trip_final <- remove_missing(clean_trip_final)

#Remove data with greater start_at than end_at
clean_trip_final<- clean_trip_final %>% 
  filter(started_at < ended_at)

# There are few prblems:
# (1) Consolidate the "member_casual" column to have consistent labels
# (2) Separate date in date, day, month, year for better analysis
# (3) Add a calculated field for length of ride since the 2020 Q1 data did not have the "tripduration" column.

# In the "member_casual" column, replace "Subscriber" with "member" and "Customer" with "casual"
# Before 2020, Divvy used different labels for these two types of riders ... we will want to make our dataframe consistent with their current nomenclature
# Seeing how many observations fall under each usertype
table(all_trips$member_casual)

# Reassign to the desired values (we will go with the current 2020 labels)
all_trips <-  all_trips %>% 
  mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))

# Check to make sure the proper number of observations were reassigned
table(all_trips$member_casual)

# Add columns that list the date, month, day, and year of each ride
clean_trip_final$date <- as.Date(clean_trip_final$started_at)
clean_trip_final$week_day <- format(as.Date(clean_trip_final$date), "%A")
clean_trip_final$month <- format(as.Date(clean_trip_final$date), "%m")
clean_trip_final$year <- format(clean_trip_final$date, "%Y")

#Separate column for time
clean_trip_final$time <- as.POSIXct(clean_trip_final$started_at, format = "%Y-%m-%d %H:%M:%S")
clean_trip_final$time <- format(clean_trip_final$time, format = "%H:%M")

#Add ride length column
clean_trip_final$ride_length <- difftime(clean_trip_final$ended_at, clean_trip_final$started_at, units = "mins")

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

#Remove stolen bikes
clean_trip_final <- clean_trip_final[!clean_trip_final$ride_length>1440,] 
clean_trip_final <- clean_trip_final[!clean_trip_final$ride_length<5,] 

#Check Cleaned data
colSums(is.na(clean_trip_final))
View(filter(clean_trip_final, clean_trip_final$started_at > clean_trip_final$ended_at))
View(filter(clean_trip_final, clean_trip_final$ride_length>1440 | clean_trip_final$ride_length < 5))

#Save the cleaned data
write.csv(clean_trip_final,file = "clean_trip_final.csv",row.names = FALSE)

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all figures in seconds)
View(describe(clean_trip_final$ride_length, fast=TRUE))

#Average ride_length for users by day_of_week and Number of total rides by day_of_week
View(clean_trip_final %>% 
       group_by(week_day) %>% 
       summarise(Avg_length = mean(ride_length),
                 number_of_ride = n()))

#Average ride length comparison by each week day according to each customer type
View(aggregate(clean_trip_final$ride_length ~ clean_trip_final$member_casual + 
                 clean_trip_final$week_day, FUN = mean))

#Average ride length comparison by each month according to each customer type
View(aggregate(clean_trip_final$ride_length ~ clean_trip_final$member_casual + 
                 clean_trip_final$month, FUN = mean))

# Fix the order of the days of the week
clean_trip_final$week_day <- ordered(clean_trip_final$week_day, levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

#Analyze rider length data by customer type and weekday
View(clean_trip_final %>% 
       group_by(member_casual, week_day) %>% 
       summarise(number_of_ride = n(),
                 avgerage_duration = mean(ride_length),
                 median_duration = median(ride_length),
                 max_duration = max(ride_length),
                 min_duration = min(ride_length)))

#Analyze rider length data by customer type and month
View(clean_trip_final %>% 
       group_by(month, member_casual) %>% 
       summarise(number_of_ride = n(),
                 average_duration = mean(ride_length),
                 median_duration = median(ride_length),
                 max_duration = max(ride_length),
                 min_duration = min(ride_length)))
#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file
write.csv(clean_trip_final,file = "clean_trip_final_visualize.csv",row.names = FALSE)




