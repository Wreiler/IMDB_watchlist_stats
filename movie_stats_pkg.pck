create or replace noneditionable package movie_stats_pkg is

  -- Author  : PROFESSIONAL
  -- Created : 23.08.2022
  -- Purpose : functions and procedures for films list analysis, stats calculations
  

  function most_common_rating(director varchar2 default '', 
                              genre varchar2 default '', 
                              decade varchar2 default '')
  return number;

end movie_stats_pkg;
/
create or replace noneditionable package body movie_stats_pkg is

  -- Function to calculate average rating of the movie by director, genre or/and decade
  function most_common_rating(director varchar2 default '', 
                              genre varchar2 default '', 
                              decade varchar2 default '') 
  return number
    is
  mc_rate number;
  begin
  
    execute immediate('
      select round(avg(t.imdb_rating), 1)
      from smorodin_sa.watchlist t
      '|| 'where t.directors like ''%' || director || '%''
      '|| 'and t.genres like ''%' || genre || '%''
      '|| 'and SUBSTR(t.release_year, 1, 3)||0 like ''%' || decade || '%''
    ')
    into mc_rate;
    
    return mc_rate;
  end;


end movie_stats_pkg;
/
