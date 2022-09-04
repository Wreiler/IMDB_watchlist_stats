# IMDB_watchlist_stats
Data analysis and visualization project based on my personal watchlist from IMDB during all the time

In this project, my IMDB watchlist was analyzed, consisting of all the films that I watched in my life (approximately)


### Old version of this analysis

The main criteria that were considered when identifying the final statistics:
- top numbers (total movies watched, most released decade, most popular director, most popular genre, most popular rating and duration intervals)
- grouping by decade of release
- grouping by project types
- grouping by rating intervals
- grouping by duration of the motion picture
- top 10 frequent directors (by number of films)
- top 10 genres (by number of films)


##### According to these criteria, visualization was compiled and presented on 3 dashboards

##### DASHBOARDS

https://public.tableau.com/app/profile/sergei5857/viz/Watchlist_dashboard_1/Dashboard1

https://public.tableau.com/app/profile/sergei5857/viz/Watchlist_dashboard_2/Dashboard2

https://public.tableau.com/app/profile/sergei5857/viz/Watchlist_dashboard_3/Dashboard3
_____________________________________

This project is being implemented as a training project in order to master the basic principles of data analysis and visualization

##### Tools used: Oracle SQL, PL/SQL developer, Tableau and Excel

###### - Views of dashboards:


![image](https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/watchlist_work1.png)

![image](https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/watchlist_work2.png)

![image](https://github.com/Wreiler/IMDB_watchlist_stats/blob/main/watchlist_work3.png)

_____________________________________________________________________________________________________
-----------------------------------------------------------------------------------------------------

### New version of this analysis

The updated version of the dashboard has the following types of summary visualization that interact with each other through the filter:
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
