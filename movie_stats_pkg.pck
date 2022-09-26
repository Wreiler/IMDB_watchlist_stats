create or replace noneditionable package movie_stats_pkg is

  -- Author  : PROFESSIONAL
  -- Created : 23.08.2022
  -- Purpose : functions and procedures for films list analysis, stats calculations
  

  function most_common_rating(director varchar2 default '', 
                              genre varchar2 default '', 
                              decade varchar2 default '',
                              country varchar2 default '')
  return num_num;
  
  function hightest_rating(director varchar2 default '', 
                           genre varchar2 default '', 
                           decade varchar2 default '',
                           country varchar2 default '') 
  return num_num;
  
  function most_common_runtime(director varchar2 default '', 
                               genre varchar2 default '', 
                               decade varchar2 default '',
                               country varchar2 default '') 
  return num_num;
  
  function hightest_runtime(director varchar2 default '', 
                            genre varchar2 default '', 
                            decade varchar2 default '',
                            country varchar2 default '') 
  return num_num;
  
  function most_common_decade(director varchar2 default '', 
                              genre varchar2 default '',
                              country varchar2 default '') 
  return num_num;
  
  function most_common_genre(director varchar2 default '', 
                             decade varchar2 default '',
                             country varchar2 default '') 
  return str_num;
  
  function most_common_director(genre varchar2 default '', 
                                decade varchar2 default '',
                                country varchar2 default '') 
  return str_num;
  
  function most_common_country(genre varchar2 default '', 
                               decade varchar2 default '',
                               director varchar2 default '') 
  return str_num;
  
  procedure create_summary_view;

end movie_stats_pkg;
/
create or replace noneditionable package body movie_stats_pkg is

  -- Function to calculate average rating of the movie by director, genre or/and decade
  function most_common_rating(director varchar2 default '', 
                              genre varchar2 default '', 
                              decade varchar2 default '',
                              country varchar2 default '') 
  return num_num
    is
  obj num_num;
  mc_rate number;
  cnt number;
  begin
  
    execute immediate('
      select round(avg(t.imdb_rating), 1)
      from ssa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
      '|| 'and t.countries like ''%' || country || '%''
    ')
    into mc_rate;
    
    execute immediate('
      select count(*)
      from ssa.watchlist t
      where t.imdb_rating = ' || mc_rate)
    into cnt;
    
    obj := num_num(mc_rate, cnt);
    
    return obj;
  end;
  
  -- Function to calculate max rating of the movie by director, genre or/and decade
  function hightest_rating(director varchar2 default '', 
                           genre varchar2 default '', 
                           decade varchar2 default '',
                           country varchar2 default '') 
  return num_num
    is
  obj num_num;
  h_rate number;
  cnt number;
  begin
  
    execute immediate('
      select round(max(t.imdb_rating), 1)
      from ssa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
      '|| 'and t.countries like ''%' || country || '%''
    ')
    into h_rate;
    
    execute immediate('
      select count(*)
      from ssa.watchlist t
      where t.imdb_rating = ' || h_rate)
    into cnt;
    
    obj := num_num(h_rate, cnt);
    
    return obj;
  end;
  
  -- Function to calculate average runtime of the movie by director, genre or/and decade
  function most_common_runtime(director varchar2 default '', 
                               genre varchar2 default '', 
                               decade varchar2 default '',
                               country varchar2 default '') 
  return num_num
    is
  obj num_num;
  mc_runtime number;
  cnt number;
  begin
  
    execute immediate('
      select round(avg(t.runtime))
      from ssa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
      '|| 'and t.countries like ''%' || country || '%''
    ')
    into mc_runtime;
    
    execute immediate('
      select count(*)
      from ssa.watchlist t
      where t.runtime = ' || mc_runtime)
    into cnt;
    
    obj := num_num(mc_runtime, cnt);
    
    return obj;
  end;
  
  -- Function to calculate max runtime of the movie by director, genre or/and decade
  function hightest_runtime(director varchar2 default '', 
                            genre varchar2 default '', 
                            decade varchar2 default '',
                            country varchar2 default '') 
  return num_num
    is
  obj num_num;
  h_runtime number;
  cnt number;
  begin
  
    execute immediate('
      select max(t.runtime)
      from ssa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
      '|| 'and t.countries like ''%' || country || '%''
    ')
    into h_runtime;
    
    execute immediate('
      select count(*)
      from ssa.watchlist t
      where t.runtime = ' || h_runtime)
    into cnt;
    
    obj := num_num(h_runtime, cnt);
    
    return obj;
  end;
  
  -- Function to calculate movie's most common decade by director or/and genre
  function most_common_decade(director varchar2 default '', 
                              genre varchar2 default '',
                              country varchar2 default '') 
  return num_num
    is
  obj num_num;
  mc_decade number;
  cnt number;
  begin
  
    execute immediate('
      select max(decade) keep (dense_rank first order by cnt desc), max(cnt)
      from (select t.decade, count(*) cnt
            from (select w.*, SUBSTR(w.release_year, 1, 3)||0 decade
                  from ssa.watchlist w) t
            '|| 'where t.directors like ''%' || director || '%''
            '|| 'and t.genres like ''%' || genre || '%''
            '|| 'and t.countries like ''%' || country || '%''
            group by t.decade)
    ')
    into mc_decade, cnt;
    
    obj := num_num(mc_decade, cnt);
    
    return obj;
  end;
  
  -- Function to calculate movie's most common genre by director or/and genre
  function most_common_genre(director varchar2 default '', 
                             decade varchar2 default '',
                             country varchar2 default '') 
  return str_num
    is
  obj str_num;
  mc_genre varchar2(30);
  cnt number;
  begin
  
    execute immediate('
      select max(genres) keep (dense_rank first order by cnt desc), max(cnt)
      from (select t.genres, count(*) cnt
            from (select distinct
                   t.title,
                   t.directors,
                   t.release_year,
                   t.countries,
                   trim(regexp_substr(t.genres, ''[^,]+'', 1, levels.column_value)) as genres
                 from 
                   ssa.watchlist t,
                   table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.genres, ''[^,]+''))  + 1) as sys.OdciNumberList)) levels
                 order by title) t
            '|| 'where t.directors like ''%' || director || '%''
            '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
            '|| 'and t.countries like ''%' || country || '%''
            group by t.genres)
    ')
    into mc_genre, cnt;
    
    obj := str_num(mc_genre, cnt);
    
    return obj;
  end;
  
  -- Function to calculate movie's most common director by director or/and genre
  function most_common_director(genre varchar2 default '', 
                                decade varchar2 default '',
                                country varchar2 default '') 
  return str_num
    is
  obj str_num;
  mc_director varchar2(50);
  cnt number;
  begin
  
    execute immediate('
      select max(directors) keep (dense_rank first order by cnt desc), max(cnt)
      from (select t.directors, count(*) cnt
            from (select distinct
                   t.title,
                   t.genres,
                   t.release_year,
                   t.countries,
                   trim(regexp_substr(t.directors, ''[^,]+'', 1, levels.column_value)) as directors
                 from 
                   ssa.watchlist t,
                   table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.directors, ''[^,]+''))  + 1) as sys.OdciNumberList)) levels
                 order by title) t
            where t.directors is not null
            '|| 'and t.genres like ''%' || genre || '%''
            '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
            '|| 'and t.countries like ''%' || country || '%''
            group by t.directors)
    ')
    into mc_director, cnt;
    
    obj := str_num(mc_director, cnt);
    
    return obj;
  end;
  
  -- Function to calculate movie's most common country by director or/and genre
  function most_common_country(genre varchar2 default '', 
                               decade varchar2 default '',
                               director varchar2 default '') 
  return str_num
    is
  obj str_num;
  mc_country varchar2(50);
  cnt number;
  begin
  
    execute immediate('
      select max(countries) keep (dense_rank first order by cnt desc), max(cnt)
      from (select t.countries, count(*) cnt
            from (select distinct
                   t.title,
                   t.genres,
                   t.release_year,
                   t.directors,
                   trim(regexp_substr(t.countries, ''[^,]+'', 1, levels.column_value)) as countries
                 from 
                   ssa.watchlist t,
                   table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.countries, ''[^,]+''))  + 1) as sys.OdciNumberList)) levels
                 order by title) t
            where t.countries is not null
            '|| 'and t.genres like ''%' || genre || '%''
            '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
            '|| 'and t.directors like ''%' || director || '%''
            group by t.countries)
    ')
    into mc_country, cnt;
    
    obj := str_num(mc_country, cnt);
    
    return obj;
  end;
  
  -- Procedure to create summary view for the watched
  procedure create_summary_view is
  begin
    execute immediate('
      create or replace view summary_watched as
        select 
         (select count(*) from WATCHLIST) total_count,
         ssa.movie_stats_pkg.most_common_rating().value || '' ('' || ssa.movie_stats_pkg.most_common_rating().count || '' titles)'' most_common_rating,
         ssa.movie_stats_pkg.most_common_runtime().value || '' ('' || ssa.movie_stats_pkg.most_common_runtime().count || '' titles)'' most_common_runtime,
         ssa.movie_stats_pkg.most_common_decade().value || '' ('' || ssa.movie_stats_pkg.most_common_decade().count || '' titles)'' most_common_decade,
         ssa.movie_stats_pkg.most_common_director().value || '' ('' || ssa.movie_stats_pkg.most_common_director().count || '' titles)'' most_common_director,
         ssa.movie_stats_pkg.most_common_genre().value || '' ('' || ssa.movie_stats_pkg.most_common_genre().count || '' titles)'' most_common_genre,
         ssa.movie_stats_pkg.most_common_country().value || '' ('' || ssa.movie_stats_pkg.most_common_country().count || '' titles)'' most_common_country
        from dual
    ');
    
    execute immediate('grant select on summary_watched to public');
  end;


end movie_stats_pkg;
/
