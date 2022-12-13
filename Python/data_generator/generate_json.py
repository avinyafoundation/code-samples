import json
import requests


data = [
    {
        "active": False,
        "name": "test",
        "global_type": "test",
        "foundation_type": "test",
        "focus": "test",
        "level": -1,
    }
    for i in range(10)
]

for i, d in enumerate(data):
    d["name"] = f"name_test_{i}"
    d["global_type"] = f"global_type_test_{i}"
    d["foundation_type"] = f"foundation_type_test_{i}"
    d["focus"] = f"focus_test_{i}"
    d["level"] = i * -1


print(json.dumps(data))

# for each json in data post to a URL with the json as the body
url = "http://localhost:9090/api/v1/program/"
for d in data:
    r = requests.post(url, json=d)
    print(r.status_code)


