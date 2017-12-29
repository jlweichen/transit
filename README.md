## A Data Analysis Project Using R to Analyze the Chicago 'L'


This project is to use open data and the Twitter API to look at activity around the Chicago area, especially along the Blue Line of the 'L'.

### Inspiration

I visited Chicago in the summer of 2017 for the first time and thoroughly enjoyed my stay. The 'L' is known to railfans around the world as one of the most extensive elevated rapid transit lines in the United States. As someone interested in statistics and public transportation, I sought to use my skills to explore the data about the line.

### Data

CTA data was taken from the website https://data.cityofchicago.org/. Twitter data was accessed throught the free API utilizing the twitteR library. Using the dplyr package I used tibbles as much as possible to manipulate the data.

### The Code

The first step is using the ridership data. The file blueline.r is first run to parse the data table for only the Blue Line stops. It creates an Rdata file that saves data tables with station data, ridership for all 33 stops, and a list of average daily ridership.
The second step is using the Twitter API. The file twitterChicago.r is run, first importing the Blue Line data

### Imaging

I am using the ggplot2 library to make graphs using the data showing the most popular stops.
![map of Chicago](/Chicagobluetwitter.png)
![heat map of the Loop, WIcker Park] (https://github.com/jlweichen/transit/blob/master/maps/Ctabluelineloop3.png)
