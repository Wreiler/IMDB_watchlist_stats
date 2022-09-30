-- base
select * 
from WATCHLIST t
order by t.title;

-- global numbers
with rating_stat as (select rate || ' - ' || (rate+1) range_rate, c
                     from
                     (select floor(t.imdb_rating) rate, count(*) c from WATCHLIST t
                     group by floor(t.imdb_rating)
                     order by c desc)),
     runtime_stat as (select runtime, count(*) c 
                      from (select case 
                                when t.runtime < 60 then '< 1H' 
                                when (t.runtime >= 60 and t.runtime < 120) then '1H - 2H'
                                when (t.runtime >= 120 and t.runtime < 180) then '2H - 3H'
                                when t.runtime >= 180 then '> 3H' end runtime
                            from WATCHLIST t)
                      group by runtime
                      order by c desc),
     decade_stat as (select SUBSTR(t.release_year, 1, 3)||0 decade, count(*) c from WATCHLIST t
                     group by SUBSTR(t.release_year, 1, 3)||0
                     order by count(*) desc),
     directors_stat as (select t.directors, count(*) c 
                        from (select distinct
                          t.title,
                          trim(regexp_substr(t.directors, '[^,]+', 1, levels.column_value))  as directors
                        from 
                          WATCHLIST t,
                          table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.directors, '[^,]+'))  + 1) as sys.OdciNumberList)) levels
                        order by title) t
                        group by t.directors
                        having t.directors is not null
                        order by c desc, t.directors),
     genres_stat as (select t.genres, count(*) c 
                     from (select distinct
                       t.title,
                       trim(regexp_substr(t.genres, '[^,]+', 1, levels.column_value))  as genres
                     from 
                       WATCHLIST t,
                       table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.genres, '[^,]+'))  + 1) as sys.OdciNumberList)) levels
                     order by title) t
                     group by t.genres
                     having t.genres is not null
                     order by c desc)
select 
   (select count(*) from WATCHLIST) total_count,
   (select range_rate || ' (' || c || ' titles)' from rating_stat where rownum = 1) most_common_rating,
   (select runtime || ' (' || c || ' titles)' from runtime_stat where rownum = 1) most_common_runtime,
   (select decade || ' (' || c || ' titles)' from decade_stat where rownum = 1) most_common_decade,
   (select directors || ' (' || c || ' titles)' from directors_stat where rownum = 1) most_common_director,
   (select genres || ' (' || c || ' titles)' from genres_stat where rownum = 1) most_common_genre
from dual;

-- view statistics by decade
select SUBSTR(t.release_year, 1, 3)||0, count(*) from WATCHLIST t
group by SUBSTR(t.release_year, 1, 3)||0
order by count(*) desc;

-- view statistics by types
select t.type, count(*) from WATCHLIST t
group by t.type
order by count(*) desc;

-- view statistics by rating
select rate || ' - ' || (rate+1) range_rate, c
from (select floor(t.imdb_rating) rate, count(*) c from WATCHLIST t
group by floor(t.imdb_rating)
order by c desc);

-- view statistics by runtime
select runtime, count(*) c 
from (select case 
             when t.runtime < 60 then '< 1H' 
             when (t.runtime >= 60 and t.runtime < 120) then '1H - 2H'
             when (t.runtime >= 120 and t.runtime < 180) then '2H - 3H'
             when t.runtime >= 180 then '> 3H' end runtime
      from WATCHLIST t)
group by runtime
order by c desc;

-- view statistics by directors (10 most common)
select * from (select t.directors, count(*) c 
               from (select distinct
                 t.title,
                 trim(regexp_substr(t.directors, '[^,]+', 1, levels.column_value))  as directors
               from 
                 WATCHLIST t,
                 table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.directors, '[^,]+'))  + 1) as sys.OdciNumberList)) levels
               order by title) t
               group by t.directors
               having t.directors is not null
               order by c desc, t.directors)
where rownum < 11;

-- view statistics by genres (10 most common)
select * from (select t.genres, count(*) c 
               from (select distinct
                 t.title,
                 trim(regexp_substr(t.genres, '[^,]+', 1, levels.column_value))  as genres
               from 
                 WATCHLIST t,
                 table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.genres, '[^,]+'))  + 1) as sys.OdciNumberList)) levels
               order by title) t
               group by t.genres
               having t.genres is not null
               order by c desc)
where rownum < 11;
