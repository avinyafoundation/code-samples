# Student application mutation flow: 
# add_student_applicant -> add_application 
# (accept the applicant) -> update_person_avinya_type -> update_application_status -> add_empower_parent

# The following code adds 200 student applications, then accepts 120 of the student applications 
# and adds two parents, 1 parent or a guardian to each student

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

add_vacancy_template = """
mutation {
    add_vacancy(
        vacancy: {
            name: "Student Application"
            head_count: 120
        }
    ){
        id
    }
}
"""

add_student_applicant_template = """
mutation{{
    add_student_applicant(
        person: {{
            preferred_name: "{preferred_name}"
            phone: {phone}
            organization_id: {organization_id}
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
            vacancy_id: 1
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
        newAvinyaId: 37
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

add_empower_parent_template = """
mutation {
    add_empower_parent(
        person: {
            preferred_name: "%s"
            phone: %s
            child_student: %s
        }
    ) {
        id
    }
}
"""

add_empower_guardian_template = """
mutation{
    add_person(
        person: {
            preferred_name: "%s",
            phone: %s
            child_student: %s
        }
        avinya_type_id: 40
    ){
        id
    }
}
"""

url = "http://localhost:4000/graphql"

# adding a student vacancy
vacancyResponse = requests.post(url, json={'query': add_vacancy_template})
print(vacancyResponse.json())

# Adding 200 student applicants
for i in range(1,201):

    preferred_name = generate_random_string(10)
    phone = generate_random_phone_number()

    # add_student_applicant
    studentApplicantMutation = add_student_applicant_template.format(preferred_name=preferred_name, phone=phone, organization_id=2)
    studentApplicantResponse = requests.post(url, json={"query": studentApplicantMutation})
    print(studentApplicantResponse.json())

    # add_application
    addApplicationMutation = add_application_template.format(person_id=i)
    addApplicationResponse = requests.post(url, json={"query": addApplicationMutation})
    print(addApplicationResponse.json())

# Accepting 120 student applicants, updating their application status and adding their parents
current_date = datetime.strptime("2022-12-14", "%Y-%m-%d")

# Loop through ids 1 to 120
for id in range(1, 121):
    preferred_name = generate_random_string(10)
    phone = generate_random_phone_number()
    transition_date = current_date - timedelta(days=random.randint(1, 365))
    
    # update_person_avinya_type
    updatePersonAvinyaTypeMutation = update_person_avinya_type_template % (id, transition_date.strftime("%Y-%m-%d"))
    updatePersonAvinyaTypeResponse = requests.post(url, json={"query": updatePersonAvinyaTypeMutation})
    print(updatePersonAvinyaTypeResponse.json())

    # update_application_status
    updateApplicationStatusMutation = update_application_status_template % (id)
    updateApplicationStatusMutationResponse = requests.post(url, json={"query": updateApplicationStatusMutation})
    print(updateApplicationStatusMutationResponse.json())

    if(id > 100):
        if(id < 111):
            # add only 1 parent
            addEmpowerParent1Mutation = add_empower_parent_template % (preferred_name, phone, [id])
            addEmpowerParent1Response = requests.post(url, json={"query": addEmpowerParent1Mutation})
            print(addEmpowerParent1Response.json())
        else:
            # add only a guardian
            addEmpowerGuardianMutation = add_empower_guardian_template % (preferred_name, phone, [id])
            addEmpowerGuardianResponse = requests.post(url, json={"query": addEmpowerGuardianMutation})
            print(addEmpowerGuardianResponse.json())
    else:
        # add two parents

        # add_empower_parent 1
        addEmpowerParent1Mutation = add_empower_parent_template % (preferred_name, phone, [id])
        addEmpowerParent1Response = requests.post(url, json={"query": addEmpowerParent1Mutation})
        print(addEmpowerParent1Response.json())

        preferred_name = generate_random_string(10)
        phone = generate_random_phone_number()

        # # add_empower_parent 2
        addEmpowerParent2Mutation = add_empower_parent_template % (preferred_name, phone, [id])
        addEmpowerParent2Response = requests.post(url, json={"query": addEmpowerParent2Mutation})
        print(addEmpowerParent2Response.json())
