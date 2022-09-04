-- Create table
create table WATCHLIST
(
  title        VARCHAR2(250) not null,
  type         VARCHAR2(20),
  imdb_rating  NUMBER,
  runtime      NUMBER,
  release_year NUMBER,
  genres       VARCHAR2(300),
  release_date DATE,
  directors    VARCHAR2(300),
  countries    VARCHAR2(400)
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table WATCHLIST
  is '—татистика всех просмотренных фильмов';
-- Add comments to the columns 
comment on column WATCHLIST.title
  is 'Movie/TV show title';
comment on column WATCHLIST.type
  is 'Title type';
comment on column WATCHLIST.imdb_rating
  is 'Rating on IMDB';
comment on column WATCHLIST.runtime
  is 'Duration (minutes)';
comment on column WATCHLIST.release_year
  is 'Release year';
comment on column WATCHLIST.genres
  is 'Title genres';
comment on column WATCHLIST.release_date
  is 'Release date';
comment on column WATCHLIST.directors
  is 'Directors and authors';
comment on column WATCHLIST.countries
  is 'Countries of origin';
-- Create/Recreate primary, unique and foreign key constraints 
alter table WATCHLIST
  add constraint TITLE_UNI unique (TITLE)
  disable
  novalidate;
