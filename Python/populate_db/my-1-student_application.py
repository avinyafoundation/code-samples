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
    phone = "".join(str(random.randint(0, 9)) for i in range(10))
    return int(phone)

add_vacancy_template = """
mutation addVacancy($vacancy: Vacancy!)
  {
      add_vacancy(vacancy:$vacancy){
      id
      name
      head_count
  }
}
"""

add_vacancy_variables = {"vacancy": {"name": "Student Application", "head_count": 120}}


add_student_applicant_template = """
mutation addStudent($person: Person!){
    add_student_applicant(
        person: $person
    ){
        id
    }
}
"""

add_application_template = """
mutation addApplication($application: Application!) {
    add_application(
        application: $application
    ){
        id
        applicant{
            id
        }
    }
}
"""

update_person_avinya_type_template = """
mutation updatePersonAvinyaType($personId: Int!, $newAvinyaId: Int!, $transitionDate: String!) {
    update_person_avinya_type(
        personId: $personId
        newAvinyaId: $newAvinyaId
        transitionDate: $transitionDate
    ) {
        id
    }
}
"""

update_application_status_template = """
mutation updateApplicationStatus($applicationId: Int!, $applicationStatus: String!){
    update_application_status(
        applicationId: $applicationId
        applicationStatus: $applicationStatus
    ) {
        application_id
    }
}
"""

add_empower_parent_template = """
mutation addEmpowerParent($person: Person!) {
    add_empower_parent(
        person: $person
    ) {
        id
    }
}
"""

add_empower_guardian_template = """
mutation addEmpowerGuardian($person: Person!) {
    add_person(
        person: $person
    ){
        id
    }
}
"""

url = "http://localhost:4000/graphql"

# adding a student vacancy
print(add_vacancy_template)
json={"query": add_vacancy_template, "variables": add_vacancy_variables}
print(json)

vacancyResponse = requests.post(url, json=json)
print(vacancyResponse.json())
vacancy_id = vacancyResponse.json()["data"]["add_vacancy"]["id"]
initial_person_id = 1
initial_application_id = 1

# Adding 200 student applicants
for i in range(1,201):

    preferred_name = generate_random_string(10)
    phone = generate_random_phone_number()

    # add_student_applicant
    #studentApplicantMutation = add_student_applicant_template.format(preferred_name=preferred_name, phone=phone)
    studentApplicantResponse = requests.post(url, json={"query": add_student_applicant_template, "variables": {"person": {"preferred_name": preferred_name, "phone": phone}}})
    print(studentApplicantResponse.json())
    person_id = studentApplicantResponse.json()["data"]["add_student_applicant"]["id"]
    if i == 1:
        initial_person_id = person_id

    # add_application
    # addApplicationMutation = add_application_template.format(person_id=i)
    addApplicationResponse = requests.post(url, json={"query": add_application_template, "variables": {"application": {"person_id": person_id, "vacancy_id": vacancy_id}}})
    print(addApplicationResponse.json())
    application_id = addApplicationResponse.json()["data"]["add_application"]["id"]
    if i == 1:
        initial_application_id = application_id

# # Accepting 120 student applicants, updating their application status and adding their parents
current_date = datetime.strptime("2022-12-14", "%Y-%m-%d")

# # Loop through ids 1 to 120
for id in range(1, 2):
# for id in range(1, 121):
    person_id = id + initial_person_id - 1
    application_id = id + initial_application_id - 1
    preferred_name = generate_random_string(10)
    phone = generate_random_phone_number()
    transition_date = current_date - timedelta(days=random.randint(1, 365))
    
    # update_person_avinya_type
    # updatePersonAvinyaTypeMutation = update_person_avinya_type_template % (id, transition_date.strftime("%Y-%m-%d"))
    updatePersonAvinyaTypeResponse = requests.post(url, json={"query": update_person_avinya_type_template, "variables": {"personId": person_id, "newAvinyaId": 37, "transitionDate": transition_date.strftime("%Y-%m-%d")}})
    print(updatePersonAvinyaTypeResponse.json())

    # update_application_status
    # updateApplicationStatusMutation = update_application_status_template % (id)
    updateApplicationStatusMutationResponse = requests.post(url, json={"query": update_application_status_template, "variables": {"applicationId": application_id, "applicationStatus": "Accepted"}})
    print(updateApplicationStatusMutationResponse.json())

    if(id > 100):
        if(id < 111):
            # add only 1 parent
            # addEmpowerParent1Mutation = add_empower_parent_template % (preferred_name, phone, [id])
            addEmpowerParent1Response = requests.post(url, json={"query": add_empower_parent_template, "variables": {"person": {"preferred_name": preferred_name, "phone": phone, "child_student": [person_id]}}})
            print(addEmpowerParent1Response.json())
        else:
            # add only a guardian
            # addEmpowerGuardianMutation = add_empower_guardian_template % (preferred_name, phone, [id])
            addEmpowerGuardianResponse = requests.post(url, json={"query": add_empower_guardian_template, "variables": {"person": {"preferred_name": preferred_name, "phone": phone, "child_student": [person_id]}}})
            print(addEmpowerGuardianResponse.json())
    else:
        # add two parents

        # add_empower_parent 1
        # addEmpowerParent1Mutation = add_empower_parent_template % (preferred_name, phone, [id])
        addEmpowerParent1Response = requests.post(url, json={"query": add_empower_parent_template, "variables": {"person": {"preferred_name": preferred_name, "phone": phone, "child_student": [person_id]}}})
        print(addEmpowerParent1Response.json())

        preferred_name = generate_random_string(10)
        phone = generate_random_phone_number()

        # add_empower_parent 2
        # addEmpowerParent2Mutation = add_empower_parent_template % (preferred_name, phone, [id])
        addEmpowerParent2Response = requests.post(url, json={"query": add_empower_parent_template, "variables": {"person": {"preferred_name": preferred_name, "phone": phone, "child_student": [person_id]}}})
        print(addEmpowerParent2Response.json())
