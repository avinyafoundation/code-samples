# The following code adds 2 security staff, 2 janitors and 2 cafeteria staff

import requests
import random
import string
from datetime import datetime, timedelta

def generate_random_string(length):
    # Generate a random string of the given length
    letters = string.ascii_lowercase
    return "".join(random.choice(letters) for i in range(length))

def generate_random_phone_number():
    # Generate a random 10-digit phone number
    return "".join(str(random.randint(0, 9)) for i in range(10))

add_person_template = """
mutation{
    add_person(
        person: {
            preferred_name: "%s",
            phone: %s
        }
        avinya_type_id: %s
    ){
        id
    }
}
"""

url = "http://localhost:4000/graphql"

avinya_id = 62

# add (2 each) security, janitorial, cafeteria staff
for i in range(3):
    for j in range(2):
        preferred_name = generate_random_string(10)
        phone = generate_random_phone_number()

        addPersonMutation = add_person_template % (preferred_name, phone, avinya_id)
        addPersonResponse = requests.post(url, json={"query": addPersonMutation})
        print(addPersonResponse.json())
    avinya_id += 1

