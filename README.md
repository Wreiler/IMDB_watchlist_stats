# IMDB_watchlist_stats
Data analysis and visualization project based on my personal watchlist from IMDB during all the time

In this project, my IMDB watchlist was analyzed, consisting of all the films that I watched in my life (approximately)

_____________________________________________________________________________________________________
-----------------------------------------------------------------------------------------------------

### New version of this analysis

These dashboards have the following types of summary visualization that interact with each other through the filter:
- the area chart of the number of pictures watched by their release date
- the donut chart the number of pictures by their release decade and percentage distribution
- the donut chart the number of pictures by their runtime and percentage distribution
- the donut chart the number of pictures by their genres and percentage distribution
- the table grouping by project types
- the tables / lists of pictures displayed during filtering (LIST, LIST OF MOVIES)
- the table grouping by project directors
- the histogram of the dependence of the films rating on the year, titles filtered by director


##### According to these criteria, visualization was compiled and presented on 2 dashboards

##### DASHBOARDS

https://public.tableau.com/app/profile/sergei5857/viz/watchlist_new_1/MAINDASH

https://public.tableau.com/app/profile/sergei5857/viz/watchlist_new_2/DIRECTORDASH
_____________________________________

This project is being implemented as a training project in order to master the basic principles of data analysis and visualization

##### Tools used: Oracle SQL, PL/SQL developer, Tableau and Excel

###### - Views of dashboards:


![image](https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/watchlist_new_work1.png)

![image](https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/watchlist_new_work2.png)

_____________________________________________________________________________________________________
-----------------------------------------------------------------------------------------------------

### Map of watched

In addition to this analysis I decided to make the dashboard with a map of all the movies and TV shows we watched, countries of origin map

It's not as accurate as we would like, since many countries can participate in the production of the film. But still it can reflect the real affiliation of the film to the country

Since downloading a watchlist from IMDB doen't take into account the country of origin I had to resort to parsing movie pages by their URL using Python and Jupiter Notebook for that

##### DASHBOARD

https://public.tableau.com/app/profile/sergei5857/viz/watchlist_new_map/COUNTRIESDASH

##### Tools used: Oracle SQL, PL/SQL developer, Tableau, Jupiter Notebook, Python, pandas, BeautifulSoup and Excel

###### - View of dashboard:

![image](https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/map_of_movies.png)

_____________________________________________________________________________________________________
-----------------------------------------------------------------------------------------------------

### Python script for setting the entire procedure to autorun on a schedule

To automate the uploading and getting the final dataset for the dashboard, I created a python script

It does these following steps:
1) load the watchlist into csv file from IMDB
2) find a difference between the new list and current list (only new items)
3) parse countries for each new item
4) merge new rows with countries into the main table in the database
5) select unified SQL query for the dashboard
6) save the results into excel file that connected to Tableau

- this application also keeps logs of this operation and writes them to the .log file

      
####### Launch of this python app is scheduled every 2 weeks by TaskTillDawn, it also shows logs after that

##### Tools used: Oracle database, Oracle SQL, Tableau, Jupiter Notebook, Python (libs: pandas, BeautifulSoup, cx_Oracle, logging), TaskTillDawn and Excel

###### - Python script

[https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/parse_and_insert_oracle.py](https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/parse_and_insert_oracle.py)
