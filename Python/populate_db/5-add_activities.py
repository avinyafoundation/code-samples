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

add_activity_template = """
mutation{{
    add_activity(
        activity:{{
            name: "{activity_name}"
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
            parent_activities: {parent_activities}
        }}
    )
    {{
        id
    }}
}}
"""

add_activity_sequence_plan_template = """
mutation {{
    add_activity_sequence_plan(
        activitySequencePlan: {{
            activity_id: {activity_id}
            sequence_number: 1
            timeslot_number: {timeslot_number}
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

add_attendance_template = """
mutation {
    add_attendance(
        attendance:{
            activity_instance_id: %s
            person_id: %s
            sign_in_time: "%s"
            sign_out_time: "%s"
        }
    ){
        id
    }
}
"""

url = "http://localhost:4000/graphql"

# adding an academic day
academicDayMutation = add_activity_template.format(activity_name="school-day")
academicDayResponse = requests.post(url, json={"query": academicDayMutation})
print(academicDayResponse.json())
academicDayId = academicDayResponse.json()["data"]["add_activity"]["id"]

# add academic day activities

activity_names = ["arrival", "breakfast-break", "homeroom", "pcti", "class-tutorial", "class-presentation","tea-break", "free-time", "lunch-break", "work", "departure"]

timeslot_number = 0

for name in activity_names:
    # add activity
    add_activity_mutation = add_children_activity_template.format(activity_name=name, parent_activities=[academicDayId])
    addActivityresponse = requests.post(url, json={"query": add_activity_mutation})
    activity_id = addActivityresponse.json()["data"]["add_activity"]["id"]
    print(addActivityresponse.json())

    # add activity to an activity sequence plan
    timeslot_number += 1

    addActivitySequencePlanMutation = add_activity_sequence_plan_template.format(activity_id=activity_id, timeslot_number=timeslot_number)
    addActivitySequencePlanResponse = requests.post(url, json={'query': addActivitySequencePlanMutation})
    print(addActivitySequencePlanResponse.json())

    # make an activity instance
    addActivityInstanceMutation = add_activity_instance_template.format(activity_id=activity_id, name=generate_random_string(10))
    addActivityInstanceResponse = requests.post(url, json={'query': addActivityInstanceMutation})
    activityInstanceId = addActivityInstanceResponse.json()["data"]["add_activity_instance"]["id"]
    print(addActivityInstanceResponse.json())

    # add activity participant and then record their attendance
    for person_id in range(1,21):
        # add the activity participant
        addActivityParticipantMutation = add_activity_participant_template % (activityInstanceId, person_id)
        addActivityParticipantResponse = requests.post(url, json={'query': addActivityParticipantMutation})
        print(addActivityParticipantResponse.json())

        # Generate a random sign in time between 2022-12-21 06:00:00 and 2022-12-21 07:00:00
        sign_in_time = generate_random_time(datetime.datetime(2022, 12, 21, 6, 0, 0), datetime.datetime(2022, 12, 21, 7, 0, 0))
        sign_in_time = sign_in_time.strftime("%Y-%m-%d %H:%M:%S")

        # Generate a random sign out time between 2022-12-21 07:00:00 and 2022-12-21 08:00:00
        sign_out_time = generate_random_time(datetime.datetime(2022, 12, 21, 7, 0, 0), datetime.datetime(2022, 12, 21, 8, 0, 0))
        sign_out_time = sign_out_time.strftime("%Y-%m-%d %H:%M:%S")

        # record participants attendance
        addAttendanceMutation = add_attendance_template % (activityInstanceId, person_id, sign_in_time, sign_out_time)
        addAttendanceResponse = requests.post(url, json={'query': addAttendanceMutation})
        print(addAttendanceResponse.json())