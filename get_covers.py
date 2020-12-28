import requests
import psycopg2
import pandas as pd
import numpy as np
from tqdm import tqdm


def get_cover(course_id):
    const_url = 'https://stepik.org/api/courses/'
    r = requests.get(const_url + str(course_id)).json()
    try:
        return const_url + r['courses'][0]['cover']
    except:
        print(f'{course_id} :((')
        return np.nan

conn = psycopg2.connect(
    host='127.0.0.1',
    user='root',
    password='stepik_password',
    database='stepik_api')

query = "SELECT * FROM courses_cluster"

data = pd.read_sql(query, con=conn)
conn.close()

data['cover'] = data['id'].apply(get_cover)

data.to_csv('cou2_2.csv')


