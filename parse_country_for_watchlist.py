#!/usr/bin/env python
# coding: utf-8

# ### Preparing the data

# In[4]:


import pandas as pd
 
watchlist_df = pd.read_excel('watchlist_new(cntry).xlsx')


# In[9]:


watchlist_df


# In[7]:


urls = watchlist_df['URL'].to_list()


# In[8]:


urls


# ### Starting the parsing

# In[78]:


from bs4 import BeautifulSoup, SoupStrainer
import httplib2
import requests
import re


# #### One URL sample

# In[61]:


url = 'https://www.imdb.com/title/tt0816692/'
response = requests.get(url)
soup = BeautifulSoup(response.content, "html.parser")


# In[62]:


links = soup.find_all('a')


# In[66]:


countries_of_made = []

for i in links:
    if i.has_attr('href'):
        if 'country_of_origin' in i['href']:
            countries_of_made += [i.get_text()]

print(', '.join(countries_of_made))


# #### All the URLs

# In[96]:


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
    
print('\nAll counties is parsed')


# In[97]:


list_of_countries #the result list with countries


# ### Joining the data with countries column

# In[98]:


column_values = pd.Series(list_of_countries)
column_values


# In[100]:


new_watchlist_df = watchlist_df.assign(Countries = column_values)


# In[101]:


new_watchlist_df


# ### Exporting in Excel file

# In[103]:


datatoexcel = pd.ExcelWriter('watchlist_countries.xlsx')
new_watchlist_df.to_excel(datatoexcel)
datatoexcel.save()
print('DataFrame is written to Excel File successfully.')

