create or replace noneditionable package movie_stats_pkg is

  -- Author  : PROFESSIONAL
  -- Created : 23.08.2022
  -- Purpose : functions and procedures for films list analysis, stats calculations
  

  function most_common_rating(director varchar2 default '', 
                              genre varchar2 default '', 
                              decade varchar2 default '')
  return num_num;
  
  function hightest_rating(director varchar2 default '', 
                           genre varchar2 default '', 
                           decade varchar2 default '') 
  return num_num;
  
  function most_common_runtime(director varchar2 default '', 
                               genre varchar2 default '', 
                               decade varchar2 default '') 
  return num_num;
  
  function hightest_runtime(director varchar2 default '', 
                            genre varchar2 default '', 
                            decade varchar2 default '') 
  return num_num;
  
  function most_common_decade(director varchar2 default '', 
                              genre varchar2 default '') 
  return num_num;
  
  function most_common_genre(director varchar2 default '', 
                             decade varchar2 default '') 
  return str_num;
  
  function most_common_director(genre varchar2 default '', 
                                decade varchar2 default '') 
  return str_num;

end movie_stats_pkg;
/
create or replace noneditionable package body movie_stats_pkg is

  -- Function to calculate average rating of the movie by director, genre or/and decade
  function most_common_rating(director varchar2 default '', 
                              genre varchar2 default '', 
                              decade varchar2 default '') 
  return num_num
    is
  obj num_num;
  mc_rate number;
  cnt number;
  begin
  
    execute immediate('
      select round(avg(t.imdb_rating), 1)
      from smorodin_sa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
    ')
    into mc_rate;
    
    execute immediate('
      select count(*)
      from smorodin_sa.watchlist t
      where t.imdb_rating = ' || mc_rate)
    into cnt;
    
    obj := num_num(mc_rate, cnt);
    
    return obj;
  end;
  
  -- Function to calculate max rating of the movie by director, genre or/and decade
  function hightest_rating(director varchar2 default '', 
                           genre varchar2 default '', 
                           decade varchar2 default '') 
  return num_num
    is
  obj num_num;
  h_rate number;
  cnt number;
  begin
  
    execute immediate('
      select round(max(t.imdb_rating), 1)
      from smorodin_sa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
    ')
    into h_rate;
    
    execute immediate('
      select count(*)
      from smorodin_sa.watchlist t
      where t.imdb_rating = ' || h_rate)
    into cnt;
    
    obj := num_num(h_rate, cnt);
    
    return obj;
  end;
  
  -- Function to calculate average runtime of the movie by director, genre or/and decade
  function most_common_runtime(director varchar2 default '', 
                               genre varchar2 default '', 
                               decade varchar2 default '') 
  return num_num
    is
  obj num_num;
  mc_runtime number;
  cnt number;
  begin
  
    execute immediate('
      select round(avg(t.runtime))
      from smorodin_sa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
    ')
    into mc_runtime;
    
    execute immediate('
      select count(*)
      from smorodin_sa.watchlist t
      where t.runtime = ' || mc_runtime)
    into cnt;
    
    obj := num_num(mc_runtime, cnt);
    
    return obj;
  end;
  
  -- Function to calculate max runtime of the movie by director, genre or/and decade
  function hightest_runtime(director varchar2 default '', 
                            genre varchar2 default '', 
                            decade varchar2 default '') 
  return num_num
    is
  obj num_num;
  h_runtime number;
  cnt number;
  begin
  
    execute immediate('
      select max(t.runtime)
      from smorodin_sa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
    ')
    into h_runtime;
    
    execute immediate('
      select count(*)
      from smorodin_sa.watchlist t
      where t.runtime = ' || h_runtime)
    into cnt;
    
    obj := num_num(h_runtime, cnt);
    
    return obj;
  end;
  
  -- Function to calculate movie's most common decade by director or/and genre
  function most_common_decade(director varchar2 default '', 
                              genre varchar2 default '') 
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
                  from smorodin_sa.watchlist w) t
            '|| 'where t.directors like ''%' || director || '%''
            '|| 'and t.genres like ''%' || genre || '%''
            group by t.decade)
    ')
    into mc_decade, cnt;
    
    obj := num_num(mc_decade, cnt);
    
    return obj;
  end;
  
  -- Function to calculate movie's most common genre by director or/and genre
  function most_common_genre(director varchar2 default '', 
                             decade varchar2 default '') 
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
                   trim(regexp_substr(t.genres, ''[^,]+'', 1, levels.column_value)) as genres
                 from 
                   smorodin_sa.watchlist t,
                   table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.genres, ''[^,]+''))  + 1) as sys.OdciNumberList)) levels
                 order by title) t
            '|| 'where t.directors like ''%' || director || '%''
            '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
            group by t.genres)
    ')
    into mc_genre, cnt;
    
    obj := str_num(mc_genre, cnt);
    
    return obj;
  end;
  
  -- Function to calculate movie's most common director by director or/and genre
  function most_common_director(genre varchar2 default '', 
                                decade varchar2 default '') 
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
                   trim(regexp_substr(t.directors, ''[^,]+'', 1, levels.column_value)) as directors
                 from 
                   smorodin_sa.watchlist t,
                   table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.directors, ''[^,]+''))  + 1) as sys.OdciNumberList)) levels
                 order by title) t
            where t.directors is not null
            '|| 'and t.genres like ''%' || genre || '%''
            '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
            group by t.directors)
    ')
    into mc_director, cnt;
    
    obj := str_num(mc_director, cnt);
    
    return obj;
  end;


end movie_stats_pkg;
/
