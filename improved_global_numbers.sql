-- global numbers
select 
   (select count(*) from WATCHLIST) total_count,
   ssa.movie_stats_pkg.most_common_rating().value || ' (' || ssa.movie_stats_pkg.most_common_rating().count || ' titles)' most_common_rating,
   ssa.movie_stats_pkg.most_common_runtime().value || ' (' || ssa.movie_stats_pkg.most_common_runtime().count || ' titles)' most_common_runtime,
   ssa.movie_stats_pkg.most_common_decade().value || ' (' || ssa.movie_stats_pkg.most_common_decade().count || ' titles)' most_common_decade,
   ssa.movie_stats_pkg.most_common_director().value || ' (' || ssa.movie_stats_pkg.most_common_director().count || ' titles)' most_common_director,
   ssa.movie_stats_pkg.most_common_genre().value || ' (' || ssa.movie_stats_pkg.most_common_genre().count || ' titles)' most_common_genre,
   ssa.movie_stats_pkg.most_common_country().value || ' (' || ssa.movie_stats_pkg.most_common_country().count || ' titles)' most_common_country
from dual;

-- or
-- using procedure in the package to create a view with this numbers
begin
    ssa.movie_stats_pkg.create_summary_view;
end;

select * from SUMMARY_WATCHED;