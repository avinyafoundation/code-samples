# Educator application mutation flow: 
# add_educator_applicant -> add_application 
# (accept the applicant) -> update_person_avinya_type -> update_application_status

# The following code adds 50 educator applications, then accepts 8 of the applications

import requests
import random
import string
from datetime import datetime, timedelta

add_educator_applicant_template = """
mutation{{
    add_educator_applicant(
        person: {{
            preferred_name: "{preferred_name}"
            phone: {phone}
        }}
    ){{
        id
    }}
}}
"""

add_application_template = """
mutation{{
    add_application(
        application: {{
            person_id: {person_id}
            vacancy_id: 2
        }}
    ){{
        applicant{{
            id
        }}
    }}
}}
"""

update_person_avinya_type_template = """
mutation {
    update_person_avinya_type(
        personId: %s
        newAvinyaId: 42
        transitionDate: "%s"
    ) {
        id
    }
}
"""

update_application_status_template = """
mutation {
    update_application_status(
        applicationId: %s
        applicationStatus: "Accepted"
    ) {
        application_id
    }
}
"""

add_vacancy_template = """
mutation {
    add_vacancy(
        vacancy: {
            name: "Educator Application"
            head_count: 8
        }
    ){
        id
    }
}
"""

def generate_random_string(length):
    # Generate a random string of the given length
    letters = string.ascii_lowercase
    return "".join(random.choice(letters) for i in range(length))

def generate_random_phone_number():
    # Generate a random 10-digit phone number
    return "".join(str(random.randint(0, 9)) for i in range(10))

url = "http://localhost:4000/graphql"

# add an educator vacancy (id 2)
vacancyResponse = requests.post(url, json={'query': add_vacancy_template})
print(vacancyResponse.json())

# Adding 50 educator applicants
for i in range(421,471):

    preferred_name = generate_random_string(10)
    phone = generate_random_phone_number()

    # add_educator_applicant
    educatorApplicantMutation = add_educator_applicant_template.format(preferred_name=preferred_name, phone=phone)
    educatorApplicantResponse = requests.post(url, json={"query": educatorApplicantMutation})
    print(educatorApplicantResponse.json())

    # add_application
    addApplicationMutation = add_application_template.format(person_id=i)
    addApplicationResponse = requests.post(url, json={"query": addApplicationMutation})
    print(addApplicationResponse.json())

# Accepting 8 educator applicants and updating their application status
current_date = datetime.strptime("2022-12-14", "%Y-%m-%d")

# Loop through ids 420 to 428
for id in range(421, 429):
    preferred_name = generate_random_string(10)
    phone = generate_random_phone_number()
    transition_date = current_date - timedelta(days=random.randint(1, 365))
    
    # update_person_avinya_type
    updatePersonAvinyaTypeMutation = update_person_avinya_type_template % (id, transition_date.strftime("%Y-%m-%d"))
    updatePersonAvinyaTypeResponse = requests.post(url, json={"query": updatePersonAvinyaTypeMutation})
    print(updatePersonAvinyaTypeResponse.json())

    # update_application_status
    updateApplicationStatusMutation = update_application_status_template % (id-220) # - # of parents
    updateApplicationStatusMutationResponse = requests.post(url, json={"query": updateApplicationStatusMutation})
    print(updateApplicationStatusMutationResponse.json())
