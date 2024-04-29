# Cyclistic-Bike-Share-Data-Analysis

This repository contains the code and documentation for a Data Analysis Project conducted on Cyclistic's bike-share data. The project is organized into several phases, based on the APPASA process (Ask - Prepare - Process - Analyze - Share - Act), including data cleaning,  data visualizations and recommendations. 

## Table of Contents

- [Phase 1: Ask](https://github.com/edward1503/Cyclistic-Bike-Share-Data-Analysis/blob/main/README.md#phase-1-ask)
- [Phase 2: Prepare](https://github.com/edward1503/Cyclistic-Bike-Share-Data-Analysis/blob/main/README.md#phase-2-prepare)
- [Phase 3: Process](https://github.com/edward1503/Cyclistic-Bike-Share-Data-Analysis/blob/main/README.md#phase-3-process)
- [Phase 4: Analyze](
## Project Overview

Cyclistic, a bike-sharing company, has provided data on bike rides taken by its customers. The goal of this project is to analyze the data, gain insights into customer behavior, and provide actionable recommendations to improve Cyclistic's bike-sharing service.

## Phase 1: Ask

In order to guide the future marketing campaign, the director of marketing assigned me the question: 

**How do annual members and casual riders use Cyclistic bikes differently?**

This phase will elaborate on the business task and consider key stakeholders.

1. Business Task
 
In order to maximize the number of annual membership, me as a data analyst, will find trend and patterns among casual riders and membership riders, and identify potential riders who can get benefit from annual membership. I do not need to raise awareness of annual membership among casual riders as they are already aware of the program. 

2. Stakeholders

- The director of marketing
- The marketing analysis team
- Cyclistic's Executive team

3. Stakeholder's expectation

Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. The marketing team is interested in analyzing the Cyclistic historical bike trip data to identify trends.

## Phase 2: Prepare

The datasets I am using here are from Cyclistic's history trip data of each month in first quarter of 2019 and 2020 and were made available by Motivate International Inc. Due to privacy issues, personal information has been removed or encrypted. 

To verify the data's integrity, I will examine it to have a broader view about the data.

Download the files from [divvy-trip-data](https://divvy-tripdata.s3.amazonaws.com/index.html) in .zip format then unzip the .csv files. 

The datasets include:
 - ride_id: id of each ride.
 - rideable_type: ride's type.
 - started_at: start time of ride.
 - ended_at: end time of ride.
 - start_station_name: ride starting station.
 - start_station_id: start station id.
 - end_station_name: ride ending station.
 - end_station_id: end station id.
 - start_lat: starting location latitude.
 - start_lng: starting location longitude.
 - end_lat: ending location latitude.
 - end_lng: ending location longitude.
 - member_casual: type of membership.

## Phase 3: Process

This phase includes the data cleaning process.

 - Sort the data ascending by start-time, calculating ride-length based on start-time and end-time and day of week.
 - Remove null, duplicate values and make columns consistency.
 - Seperate date, time to week day, month, time.

## Phase 4: Analyze

In this phase, I will analyze the data by member type for each time (day, hour, week...) to identify trend and pattern. 
 - Analyze ride length by customer type and week day.
 - Analyze ride length comparison for each month.
 - ...

## Phase 5: Visualization

This phase will help stakeholders to take a closer look to what data telling. These visualizations will include **charts, graphs, and other visual representations** of the data that will help **highlight important patterns** and **relationships** in the data.
- Rides per day for each customer type.
- Rides per hour for each customer type.
- Rides per month for each customer type.
- Ride duration per time for each customer type.

## Phase 6: Act

This phase will conclude with some key takeaways and recommendations for Cyclistic's marketing campaign. 
