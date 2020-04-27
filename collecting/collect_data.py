import pandas as pd
import requests
from tqdm import tqdm 
import argparse

# Collecting info about different courses 
def get_courses(n_pages, features=['id', 'title', 'summary', 'description', 'is_paid', 'lessons_count']):
    constant_url = 'https://stepik.org:443/api/courses'
    courses = []
    for i in tqdm(range(1, n_pages + 1)):
        req = requests.get(constant_url, params={'page': i}).json()['courses']
        # если словарь, то докидываем курс в список
        if req.__class__ == {}.__class__:
            #print(req['quizzes_count'])
            # проверяем на условия
            if int(req['learners_count']) >= 70 and int(req['lessons_count']) >= 10 \
            and int(req['quizzes_count']) >= 5:
                courses.append(r)
            else:
                pass
        # если список, то разворачиваем список
        elif req.__class__ == [].__class__:
            #проверяем условия для каждого курса
            for j in req:
                if int(j['learners_count']) >= 70 and int(j['lessons_count']) >= 10 \
                and int(j['quizzes_count']) >= 5:
                    courses.append(j)
                else:
                    pass

    if len(courses) == 0:
        print("No satifying courses")
        exit()
    final_courses = pd.DataFrame(courses)
    final_courses = final_courses[final_courses['language'].apply(lambda x: x in ['ru', 'en'])]
    final_courses = final_courses[features]
    print(f"Saved {len(courses)} courses")
    return final_courses

# Collecting info about reviews from collected courses 
def get_reviews(courses_id):    
    url = "https://stepik.org/api/course-reviews?course="
    all_reviews = []
    for c_id in tqdm(courses_id):
        info = requests.get(url+str(c_id)).json()['course-reviews']
        all_reviews.extend(info)
    reviews = pd.DataFrame(all_reviews)
    if reviews.shape[0] == 0:
        print("There no reviews")
        exit()
    print(f"Collected {reviews.shape[0]} reviews")
    return reviews

# Collecting info about users from collected reviews
def get_users(users_id):
    users_info = []
    for user_id in tqdm(set(users_id)):
        info = requests.get(f"https://stepik.org/api/users/{user_id}").json()['users']
        users_info.extend(info)
    users = pd.DataFrame(users_info)
    print(f"Collected info about {users.shape[0]} users")
    return users


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--n_courses", 
        help="number of courses to check during running the script, less number could be collected", 
        type=int)

    args = parser.parse_args()
    n_courses = args.n_courses

    courses = get_courses(n_courses)
    courses.to_csv('courses_test.csv', index=False)
    print("__________________\n")

    reviews = get_reviews(courses.id)
    reviews.to_csv('reviews_test.csv', index=False)
    print("__________________\n")

    users = get_users(reviews.user)
    users.to_csv('users_test.csv', index=False)

