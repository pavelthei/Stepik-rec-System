import pandas as pd
import requests
from tqdm import tqdm 

N_PAGES = 1000
constant_url = 'https://stepik.org:443/api/courses'
courses = []
for i in tqdm(range(1, N_PAGES + 1)):
    req = requests.get(constant_url, params={'page': i}).json()['courses']
    # если словарь, то докидываем курс в список
    if req.__class__ == {}.__class__:
    	# проверяем на условия
    	if req['learners_count'] >= 70 and req['lessons_count'] >= 10 \
    	and req['quizzes_count'] >= 5:
    		courses.append(r)
    	else:
    		pass
    # если список, то разворачиваем список
    elif req.__class__ == [].__class__:
    	#проверяем условия для каждого курса
    	for j in req:
    		if j['learners_count'] >= 70 and j['lessons_count'] >= 10 \
    		and j['quizzes_count'] >= 5:
    			courses.append(j)
    		else:
    			pass
pd.DataFrame(courses).to_csv('courses.csv')
print(f"Saved {len(courses)} courses")
