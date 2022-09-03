-- global numbers
select 
   (select count(*) from WATCHLIST) total_count,
   smorodin_sa.movie_stats_pkg.most_common_rating().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_rating().count || ' titles)' most_common_rating,
   smorodin_sa.movie_stats_pkg.most_common_runtime().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_runtime().count || ' titles)' most_common_runtime,
   smorodin_sa.movie_stats_pkg.most_common_decade().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_decade().count || ' titles)' most_common_decade,
   smorodin_sa.movie_stats_pkg.most_common_director().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_director().count || ' titles)' most_common_director,
   smorodin_sa.movie_stats_pkg.most_common_genre().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_genre().count || ' titles)' most_common_genre
from dual;
