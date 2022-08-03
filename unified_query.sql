-- query for the most important
with origin as (select t.*, 
                       SUBSTR(t.release_year, 1, 3)||0 decade, 
                       floor(t.imdb_rating) || ' - ' || (floor(t.imdb_rating)+1) range_rate,
                       case 
                             when t.runtime < 60 then '< 1H' 
                             when (t.runtime >= 60 and t.runtime < 120) then '1H - 2H'
                             when (t.runtime >= 120 and t.runtime < 180) then '2H - 3H'
                             when t.runtime >= 180 then '> 3H' 
                       end runtime_rate
                from WATCHLIST t)
select org.title,
       org.type,
       org.imdb_rating,
       org.range_rate,
       org.runtime,
       org.runtime_rate,
       org.release_date,
       org.release_year,
       org.decade,
       res.genre,
       res.director
from (select distinct t.title,
             trim(regexp_substr(t.directors, '[^,]+', 1, levels_1.column_value))  as director,
             trim(regexp_substr(t.genres, '[^,]+', 1, levels_2.column_value))  as genre
      from origin t,
           table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.directors, '[^,]+'))  + 1) as sys.OdciNumberList)) levels_1,
           table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.genres, '[^,]+'))  + 1) as sys.OdciNumberList)) levels_2
       order by title) res,
      origin org
where org.title = res.title;
