import pandas as pd
from bs4 import BeautifulSoup, SoupStrainer
import requests
import cx_Oracle
import logging


# set up a logger and its configure for the first launch message
file_log1 = logging.FileHandler('Log.log')
console_out1 = logging.StreamHandler()
logging.basicConfig(handlers=(file_log1, console_out1), 
                    format='-----[%(levelname)s]: %(message)s - %(asctime)s-----', 
                    datefmt='%m.%d.%Y',
                    level=logging.INFO)
logger1 = logging.getLogger(__name__)
logger1.info('New unloading from IMDB')

for handler in logging.root.handlers[:]:
    logging.root.removeHandler(handler)

# set up a new logger and its configure for the rest of launch messages
file_log = logging.FileHandler('Log.log')
console_out = logging.StreamHandler()
logging.basicConfig(handlers=(file_log, console_out), 
                    format='[%(asctime)s | %(levelname)s]: %(message)s', 
                    datefmt='%m.%d.%Y %H:%M:%S',
                    level=logging.INFO)
logger = logging.getLogger(__name__)

# set up the trigger
trigger = 0

def load_from_IMBD():
    # load the watchlist csv file from imdb
    file_url = 'https://www.imdb.com/list/ls500862579/export'
    file_object = requests.get(file_url)
    with open('C:\BASE\Code\IMDb_WL_research\WATCHLIST.csv', 'wb') as local_file:
        local_file.write(file_object.content)
    logger.info('Unloading .csv from IMDB is completed')
    print('\nUnloading .csv from IMDB is completed.')

def parse_and_insert():
    global trigger
    
    # get the new list and current list dataframes
    wl_imdb_df = pd.read_csv('C:\BASE\Code\IMDb_WL_research\WATCHLIST.csv').iloc[:, 5:]
    del wl_imdb_df['Num Votes']
    cols = wl_imdb_df.columns.tolist()
    cols = [cols[0]] + cols[2:] + [cols[1]]
    wl_imdb_df = wl_imdb_df[cols]

    cx_Oracle.init_oracle_client(r'C:\BASE\warehouse\progs\WINDOWS.X64_193000_db_home\bin')

    conn = None
    conn = cx_Oracle.connect('SSA/Wreiler1909@orcl')

    wl_orcl_df = pd.read_sql('SELECT * FROM WATCHLIST', conn)

    conn.close()

    # find the difference between them (the new ones dataframe)
    res_df = wl_imdb_df[~wl_imdb_df.index.isin(wl_orcl_df.index)]

    # find the urls of new ones
    urls = res_df['URL'].to_list()

    if urls == []:
        logger.info('There is nothing to update.')
        print('\nThere is nothing to update.')
        trigger = 1
        return

    # parse countries of the new ones
    #------------
    list_of_countries = []
    cnt = 0

    for link in urls:
        countries_of_made = []
        cnt += 1
        response = requests.get(link)
        soup = BeautifulSoup(response.content, "html.parser", parse_only=SoupStrainer('a'))
        for i in soup:
            if i.has_attr('href'):
                if 'country_of_origin' in i['href']:
                    countries_of_made += [i.get_text()]
        print(cnt, ', '.join(countries_of_made))
        list_of_countries.append(', '.join(countries_of_made))

    logger.info('All counties are parsed.')
    print('\nAll counties are parsed.')
    #------------

    # create the countries series and add the right indexes
    column_values = pd.Series(list_of_countries)
    column_values.index += len(wl_orcl_df)

    # add the countries column to the new ones dataframe
    new_watchlist_df = res_df.iloc[:, :-1].assign(Countries = column_values)

    # save new rows as turples for the insert
    dataInsertionTuples = [tuple(x) for x in new_watchlist_df.values]

    # insert new rows into the table in the database
    #------------
    conn = None
    conn = cx_Oracle.connect('SSA/Wreiler1909@orcl')

    try:
        cur = conn.cursor()
        
        sqlTxt = "INSERT INTO SSA.WATCHLIST\
                (TITLE, TYPE, IMDB_RATING, RUNTIME, RELEASE_YEAR, GENRES, RELEASE_DATE, DIRECTORS, COUNTRIES)\
                VALUES (:1, :2, :3, :4, :5, :6, TO_DATE(:7, 'yyyy-mm-dd'), :8, :9)"
        # execute the sql to perform data extraction
        cur.executemany(sqlTxt, dataInsertionTuples)

        rowCount = cur.rowcount
        logger.info("Number of inserted rows = " + str(rowCount))
        print("\nNumber of inserted rows = ", rowCount)

        # commit the changes
        conn.commit()
    except Exception as err:
        logger.error('Error while connecting to the db:\n' + str(err))
        print('\nError while connecting to the db:')
        print(err)
    finally:
        if(conn):
            # close the cursor object to avoid memory leaks
            cur.close()

            # close the connection object also
            conn.close()
    logger.info("Insert is completed!")
    print("Insert is completed!")
    #------------

def select_and_save():
    # select unified quety from the database
    #------------
    conn = None
    conn = cx_Oracle.connect('SSA/Wreiler1909@orcl')

    try:
        query_df = pd.read_sql("""with origin as (select t.*, 
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
                                        res.director,
                                        res.country
                                    from (select distinct t.title,
                                                trim(regexp_substr(t.directors, '[^,]+', 1, levels_1.column_value))  as director,
                                                trim(regexp_substr(t.genres, '[^,]+', 1, levels_2.column_value))  as genre,
                                                trim(regexp_substr(t.countries, '[^,]+', 1, levels_3.column_value))  as country
                                        from origin t,
                                            table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.directors, '[^,]+'))  + 1) as sys.OdciNumberList)) levels_1,
                                            table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.genres, '[^,]+'))  + 1) as sys.OdciNumberList)) levels_2,
                                            table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.countries, '[^,]+'))  + 1) as sys.OdciNumberList)) levels_3
                                        order by title) res,
                                        origin org
                                    where org.title = res.title""", conn)

        logger.info("Number of selected rows = " + str(len(query_df)))
        print("\nNumber of selected rows = ", len(query_df))

    except Exception as err:
        logger.error('Error while connecting to the db:\n' + str(err))
        print('\nError while connecting to the db:')
        print(err)
    finally:
        if(conn):
            # close the connection object also
            conn.close()
    logger.info("Select is completed!")
    print("Select is completed!")
    #------------

    # configure date column in the dataframe
    query_df['RELEASE_DATE'] = pd.to_datetime(query_df['RELEASE_DATE']).dt.strftime('%m.%d.%Y')

    # save results for Tableau dashboards into Excel file
    #------------
    datatoexcel = pd.ExcelWriter('C:\BASE\Code\IMDb_WL_research\Tableau unified table.xlsx')
    query_df.to_excel(datatoexcel, index=False, sheet_name = 'Лист1')
    datatoexcel.save()
    logger.info('DataFrame is written to Tableau Excel File successfully. All is done!')
    print('\n\nDataFrame is written to Tableau Excel File successfully. All is done!')
    #------------


load_from_IMBD()
parse_and_insert()
if trigger == 0:
    select_and_save()