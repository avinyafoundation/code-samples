# Activities mutation flow
# add_activity -> add_activity_instance -> add_activity_participant -> add_pcti_notes

# The following code adds all the classes as Organizations. It then adds all Projects as activities.
# PCTI children activities are then created for each project and organization.
# An activity instance is then created for each PCTI activity. An activity participant with id 421 is added for each activity instance.
# Finally, 3 PCTI notes are added for each activity instance by an evaluator with id 421.

import requests;
import random;
import string;
import datetime;

def generate_random_string(length):
    # Generate a random string of the given length
    letters = string.ascii_lowercase
    return "".join(random.choice(letters) for i in range(length))

def generate_random_time(start_time, end_time):
    # Generate a random number of seconds between the start and end times
    delta = end_time - start_time
    random_seconds = random.randint(0, delta.total_seconds())

    # Return the start time plus the random number of seconds
    return start_time + datetime.timedelta(seconds=random_seconds)

url = "http://localhost:4000/graphql"

add_activity_template = """
mutation{{
    add_activity(
        activity:{{
            name: "{activity_name}"
            avinya_type_id: 72
        }}
    )
    {{
        id
    }}
}}
"""

add_children_activity_template = """
mutation{{
    add_activity(
        activity:{{
            name: "{activity_name}"
            description: "{activity_description}"
            parent_activities: {parent_activities}
            avinya_type_id: {avinya_type_id}

        }}
    )
    {{
        id
    }}
}}
"""

add_organization_template = """
mutation {{
    add_organization(
        org:{{
            name_en: "{name_en}"
            description: "{description}"
            phone: {phone}
            avinya_type: 78
        }}
    ){{
        id
    }}
}}
"""

update_person_organization_template = """
mutation{{
    update_person_organization(
        newOrgId: {newOrgId}
        personId: {personId}
        transitionDate: "2023-01-26"
    ){{
        id
    }}
}}
"""

add_activity_instance_template = """
mutation{{
    add_activity_instance(
        activityInstance: {{
            activity_id: {activity_id}
            name: "{name}"
            description:"{description}"
            organization_id: {organization_id}
        }}
    ){{
        id
    }}
}}
"""

add_activity_participant_template = """
mutation{
    add_activity_participant(
        activityParticipant: {
            activity_instance_id: %s
            person_id: %s
        }
    ){
        id
    }
}
"""

add_pcti_notes = """
mutation{{
    add_pcti_notes(
        evaluation:{{
            activity_instance_id: {activity_instance_id}
            notes: "{notes}"
            evaluator_id: {evaluator_id}
        }}
    ){{
        id
    }}
}}
"""

def generate_random_string(length):
    # Generate a random string of the given length
    letters = string.ascii_lowercase
    return "".join(random.choice(letters) for i in range(length))


# adding 6 classes
class_description_names = ["Leopards", "Eagles", "Dolphins", "Bears", "Bees", "Elephants"]
class_names = ["2026 - Empower - Group 1", "2026 - Empower - Group 2", "2026 - Empower - Group 3", "2026 - Empower - Group 4", "2026 - Empower - Group 5", "2026 - Empower - Group 6"]
skills = ["CREATIVITY AND INNOVATION", "INFORMATION LITERACY", "FLEXIBILITY AND ADAPTABILITY"] 
org_ids = []

count = 0

for i in range(len(class_names)):
    phone = random.randint(1000000000, 9999999999)
    addOrganizationMutation = add_organization_template.format(name_en=class_names[i], description=class_description_names[i], phone=phone)
    addOrganizationResponse = requests.post('http://localhost:4000/graphql', json={'query': addOrganizationMutation})
    print(addOrganizationResponse.json())
    class_org_id = addOrganizationResponse.json()["data"]["add_organization"]["id"]
    org_ids.append(class_org_id)

    # adding 20 students to each class
    for i in range(20):
        count+=1
        updatePersonOrganizationMutation = update_person_organization_template.format(newOrgId=class_org_id, personId=count)
        updatePersonOrganizationResponse = requests.post('http://localhost:4000/graphql', json={'query': updatePersonOrganizationMutation})
        print(updatePersonOrganizationResponse.json())

# adding 6 projects
project_names = ["Digital Passport", "Face Off", "Fun with Food", "Let's Vlog it", "My City, My Town", "Nature Trail"]
project_activity_ids = []

for name in project_names:
    # creating project activities
    add_activity_mutation = add_activity_template.format(activity_name=name)
    addActivityresponse = requests.post(url, json={"query": add_activity_mutation})
    print(addActivityresponse.json())
    project_activity_id = addActivityresponse.json()["data"]["add_activity"]["id"]
    project_activity_ids.append(project_activity_id)

    # creating children pcti activities
    for i in range(len(org_ids)):
        add_pcti_mutation = add_children_activity_template.format(activity_name=name +" - "+ class_names[i], activity_description=name +" - "+ class_description_names[i], parent_activities=[project_activity_id], avinya_type_id=68)
        addPctiActivityresponse = requests.post(url, json={"query": add_pcti_mutation})
        pcti_activity_id = addPctiActivityresponse.json()["data"]["add_activity"]["id"]
        print(addPctiActivityresponse.json())

        # make an activity instance
        addActivityInstanceMutation = add_activity_instance_template.format(activity_id=pcti_activity_id, name=name +" - "+ class_names[i], description=name +" - "+ class_description_names[i], organization_id=org_ids[i])
        addActivityInstanceResponse = requests.post(url, json={'query': addActivityInstanceMutation})
        activityInstanceId = addActivityInstanceResponse.json()["data"]["add_activity_instance"]["id"]
        print(addActivityInstanceResponse.json())

        # add the activity participant
        addActivityParticipantMutation = add_activity_participant_template % (activityInstanceId, 421) # hardcoding person_id 421 and assuming this is a teacher
        addActivityParticipantResponse = requests.post(url, json={'query': addActivityParticipantMutation})
        print(addActivityParticipantResponse.json())

        # add the pcti notes
        for i in range(5):
            addPctiNotesMutation = add_pcti_notes.format(activity_instance_id=activityInstanceId, notes=generate_random_string(10)+ " " + generate_random_string(10)+ " " + generate_random_string(10), evaluator_id=421)
            addPctiNotesResponse = requests.post(url, json={'query': addPctiNotesMutation})
            print(addPctiNotesResponse.json())

# adding skills child activities
for skill in skills:
    add_skill_mutation = add_children_activity_template.format(activity_name=skill, activity_description=skill, parent_activities=project_activity_ids, avinya_type_id=80)
    addSkillActivityresponse = requests.post(url, json={"query": add_skill_mutation})
    print(addSkillActivityresponse.json())

        


