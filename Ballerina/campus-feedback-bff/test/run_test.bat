curl -X POST http://localhost:9090/evaluations -H "Content-Type: application.json" -d @test/evaluation.json 

curl -X POST http://localhost:9090/evaluations -H "Content-Type: application/json"  -d "[{\"evaluatee_id\":1, \"evaluator_id\": 1 , \"evaluation_criteria_id\": 1 , \"activity_instance_id\": 145 , \"updated\": \"2022-01-01T00:00:00Z\" , \"response\": \"test 1\" , \"notes\": \"Test 1\" , \"grade\":32 , \"child_evaluations\":[1] , \"parent_evaluations\":[] } , {\"evaluatee_id\":1, \"evaluator_id\": 1 , \"evaluation_criteria_id\": 1 , \"activity_instance_id\": 145 , \"updated\": \"2022-01-01T00:00:00Z\" , \"response\": \"test 2\" , \"notes\": \"Test 2\" , \"grade\":32 , \"child_evaluations\":[1] , \"parent_evaluations\":[] }]"

curl http://localhost:9090/evaluations


