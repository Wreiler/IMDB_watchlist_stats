-- global numbers
select 
   (select count(*) from WATCHLIST) total_count,
   smorodin_sa.movie_stats_pkg.most_common_rating().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_rating().count || ' titles)' most_common_rating,
   smorodin_sa.movie_stats_pkg.most_common_runtime().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_runtime().count || ' titles)' most_common_runtime,
   smorodin_sa.movie_stats_pkg.most_common_decade().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_decade().count || ' titles)' most_common_decade,
   smorodin_sa.movie_stats_pkg.most_common_director().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_director().count || ' titles)' most_common_director,
   smorodin_sa.movie_stats_pkg.most_common_genre().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_genre().count || ' titles)' most_common_genre,
   smorodin_sa.movie_stats_pkg.most_common_country().value || ' (' || smorodin_sa.movie_stats_pkg.most_common_country().count || ' titles)' most_common_country
from dual;

-- or
-- using procedure in the package to create a view with this numbers
begin
    smorodin_sa.movie_stats_pkg.create_summary_view;
end;

select * from SUMMARY_WATCHED;