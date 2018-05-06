## A Data Analysis Project Using R to Analyze the Chicago 'L'


This project is to use open data and the Twitter API to look at activity around the Chicago area, especially along transit corridors

### Inspiration

I visited Chicago in the summer of 2017 for the first time and thoroughly enjoyed my stay. The 'L' is known to railfans around the world as one of the most extensive elevated rapid transit lines in the United States. As someone interested in statistics and public transportation, I sought to use my skills to explore the data about the line.

### Data

CTA and census data was taken from the website https://data.cityofchicago.org/. Twitter data was accessed through the free API utilizing the rtweet library. I used the tidyverse packages to manipulate the data, and ggmap to create maps from the data.

### The Code

The first step is done in QuantumGIS. I used a shapefile of the city and created a point-vector grid that provides over 600 lat-long points. The Twitter API will be queried within a 1.4 mile radius from each point to canvas the city.
The second step is using the Twitter API. The file pullingTweets.r is run, first importing the points, then using each pair of the coordinates to query Twitter via the REST API for up to 1800 tweets within a 1.4 mile radius of each point. The tweets are combined into one data frame, and duplicates are removed. Tweets without exact coordinates are also removed, and the cleanTweets data frame is used to store them.

### Imaging

I am using the ggplot2 and ggmap libraries to make graphs using the data.


Heat map of the Loop area and Wicker Park showing where most tweets are made:
![heat map of the Loop and Wicker Park](/maps/Ctabluelineloop3.png)

Another heat map removing the "Chicago Metropolitan Area" Instagram posts, and job search bot tweets:
![cleaner heat map of the Loop and Wicker Park](/maps/Ctabluelineloop4.png)
