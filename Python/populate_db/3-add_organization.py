# The following code adds 7 organizations

import random
import requests

add_organization_template = """
mutation {{
    add_organization(
        org:{{
            name_en: "{name_en}"
            phone: {phone}
        }}
    ){{
        id
    }}
}}
"""

org_names = [
    "foundation-bod",
    "foundation",
    "technology-team",
    "empower-curriculum-team",
    "operations-team",
    "avinya-academies",
    "avinya-single-academy"
]

for org_name in org_names:
    # Generate a random phone number
    phone = random.randint(1000000000, 9999999999)

    # Substitute the org_name and phone into the mutation template
    addOrganizationMutation = add_organization_template.format(name_en=org_name, phone=phone)

    # Send the mutation to the server
    addOrganizationResponse = requests.post('http://localhost:4000/graphql', json={'query': addOrganizationMutation})

    # Print the response from the server
    print(addOrganizationResponse.json())
