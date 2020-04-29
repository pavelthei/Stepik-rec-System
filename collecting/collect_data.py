import pandas as pd
import requests
from tqdm import tqdm
import argparse
import psycopg2
import logging
from datetime import datetime
import os
import json


# Collecting info about different courses
def get_courses(n_pages, features=None, start_point=1):
    logging.info("Staring collecting courses")
    if features is None:
        features = ['id', 'title', 'summary', 'description', 'is_paid', 'lessons_count']
    constant_url = 'https://stepik.org:443/api/courses'
    courses = []
    for i in tqdm(range(start_point, n_pages + start_point+1)):
        req = requests.get(constant_url, params={'page': i}).json()['courses']
        # если словарь, то докидываем курс в список
        if req.__class__ == {}.__class__:

            # проверяем на условия
            if int(req['learners_count']) >= 70 and int(req['lessons_count']) >= 10 \
                    and int(req['quizzes_count']) >= 5:
                courses.append(r)
            else:
                pass
        # если список, то разворачиваем список
        elif req.__class__ == [].__class__:

            # проверяем условия для каждого курса
            for j in req:
                if int(j['learners_count']) >= 70 and int(j['lessons_count']) >= 10 \
                        and int(j['quizzes_count']) >= 5:
                    courses.append(j)
                else:
                    pass

    if len(courses) == 0:
        logging.info("No satisfying courses")
        print("No satisfying courses")
        exit()
    final_courses = pd.DataFrame(courses)
    final_courses = final_courses[final_courses['language'].apply(lambda x: x in ['ru', 'en'])]
    final_courses = final_courses[features]
    print(f"Saved {len(courses)} courses")
    logging.info(f"Saved {len(courses)} courses")
    return final_courses


# Collecting info about reviews from collected courses
def get_reviews(courses_id):
    logging.info("Staring collecting reviews")
    cols = ["id", "course", "user", "score", "text", "create_date"]
    url = "https://stepik.org/api/course-reviews?course="
    all_reviews = []
    for c_id in tqdm(courses_id):
        info = requests.get(url + str(c_id)).json()['course-reviews']
        all_reviews.extend(info)
    reviews = pd.DataFrame(all_reviews)[cols]
    reviews.columns = ["id", "course_id", "user_id", "score", "text", "create_date"]
    if reviews.shape[0] == 0:
        print("There no reviews")
        logging.info("There no reviews")
        exit()
    print(f"Collected {reviews.shape[0]} reviews")
    logging.info(f"Collected {reviews.shape[0]} reviews")
    return reviews


# Collecting info about users from collected reviews
def get_users(users_id):
    logging.info("Staring collecting users")
    cols = ["id", "full_name", "is_active", "avatar", "level", "level_title", "knowledge", "knowledge_rank",
            "reputation", "reputation_rank", "join_date", "social_profiles", "solved_steps_count",
            "created_courses_count", "created_lessons_count", "issued_certificates_count", "followers_count"]
    users_info = []
    for user_id in tqdm(set(users_id)):
        info = requests.get(f"https://stepik.org/api/users/{user_id}").json()['users']
        users_info.extend(info)
    users = pd.DataFrame(users_info)[cols]
    print(f"Collected info about {users.shape[0]} users")
    logging.info(f"Collected info about {users.shape[0]} users")
    return users


# Inserting data
def insert_data(data, table):
    cols = list(data.columns)
    data = [tuple(x) for x in data.to_numpy()]

    logging.info("Starting inserting {table}: {n} items".format(table=table, n=len(data)))

    # insert connection info by yourself
    conn = psycopg2.connect(
        host='stepik-bd.c2hf8kenf8dw.us-east-1.rds.amazonaws.com',
        user='stepik_master',
        password='Stepikpa$$word',
        database='stepik_api')

    # cursor = conn.cursor()
    query: str = "INSERT INTO {table} ({columns}) VALUES ({values}) " \
                 "ON CONFLICT DO NOTHING".format(table=table,
                                                 columns=', '.join(cols),
                                                 values=', '.join(['%s'] * len(cols)))
    cursor = conn.cursor()
    for i in tqdm(range(len(data))):
        cursor.execute(query, data[i])
        conn.commit()

    cursor.close()
    conn.close()
    logging.info("Finished inserting")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--n_courses",
                        help="number of courses to check during running the script, less number could be collected",
                        type=int)

    args = parser.parse_args()
    n_courses = args.n_courses

    columns = ['id', 'title', 'target_audience', 'is_certificate_issued',
               'description', 'authors', 'schedule_type', 'learners_count', 'quizzes_count', 'time_to_complete',
               'language']

    logging.basicConfig(filename="collecting.log", level=logging.INFO)
    logging.info("START CIRCLE\n----------\n{date:%Y-%m-%d %H:%M:%S}\n----------".format(date=datetime.now()))

    if os.path.exists("changing_values.json"):
        with open('changing_values.json', 'r') as read_file:
            ch_val = json.loads(read_file.read())
        start = ch_val['start']
        ch_val['start'] += n_courses
        with open('changing_values.json', 'w') as write_file:
            json.dump(ch_val, write_file)
    else:
        start = 1
        ch_val = {'start': 1 + n_courses}
        with open('changing_values.json', 'w') as write_file:
            json.dump(ch_val, write_file)

    print("Check courses:")
    courses = get_courses(n_courses, features=columns, start_point=start)
    print("Inserting courses to database")
    insert_data(courses, table="courses")

    print("Check reviews")
    reviews = get_reviews(courses.id)
    print("Inserting reviews to database")
    insert_data(reviews, table="reviews")

    print("Check users")
    users = get_users(reviews.user_id)
    print("Inserting users to database")
    insert_data(users, table="users")
    logging.info("FINISH CIRCLE\n----------\n{date:%Y-%m-%d %H:%M:%S}\n----------".format(date=datetime.now()))
