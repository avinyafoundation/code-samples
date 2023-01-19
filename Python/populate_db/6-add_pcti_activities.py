# Activities mutation flow
# add_activity -> add_activity_sequence_plan -> add_activity_instance -> add_activity_participant -> add_attendance

# The following code adds 11 activities for an academic day, then adds the activities to a sequence plan.
# An activity instance is created for each activity. 20 participants are added to each instance and their attendance is then recorded.

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

# project_class_names = ["Digital Passport", "Face Off", "Fun with Food", "Let's Vlog it", "My City, My Town", "Nature Trail", "Class A", "Class B", "Class C", "Class D", "Class E", "Class F"]

# adding 3 classes
class_description_names = ["Leopards", "Eagles", "Dolphins", "Bears", "Bees", "Elephants"]
class_names = ["2026 - Empower - Group 1", "2026 - Empower - Group 2", "2026 - Empower - Group 3", "2026 - Empower - Group 4", "2026 - Empower - Group 5", "2026 - Empower - Group 6"]
org_ids = []

for i in range(len(class_names)):
    phone = random.randint(1000000000, 9999999999)
    addOrganizationMutation = add_organization_template.format(name_en=class_names[i], description=class_description_names[i], phone=phone)
    addOrganizationResponse = requests.post('http://localhost:4000/graphql', json={'query': addOrganizationMutation})
    print(addOrganizationResponse.json())
    class_activity_id = addOrganizationResponse.json()["data"]["add_organization"]["id"]
    org_ids.append(class_activity_id)


# adding 6 projects
project_names = ["Digital Passport", "Face Off", "Fun with Food", "Let's Vlog it", "My City, My Town", "Nature Trail"]

for name in project_names:
    # creating project activities
    add_activity_mutation = add_activity_template.format(activity_name=name)
    addActivityresponse = requests.post(url, json={"query": add_activity_mutation})
    print(addActivityresponse.json())
    project_activity_id = addActivityresponse.json()["data"]["add_activity"]["id"]

    # creating children pcti activities
    for i in range(len(org_ids)):
        add_pcti_mutation = add_children_activity_template.format(activity_name=name +" - "+ class_names[i], activity_description=name +" - "+ class_description_names[i], parent_activities=[project_activity_id])
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

        


