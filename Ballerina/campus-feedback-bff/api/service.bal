import ballerina/log;
import ballerina/graphql;
import ballerina/http;

public function initClientConfig() returns ConnectionConfig {
    ConnectionConfig _clientConig = {};
    if (GLOBAL_DATA_USE_AUTH) {
        _clientConig.oauth2ClientCredentialsGrantConfig = {
            tokenUrl: CHOREO_TOKEN_URL,
            clientId: GLOBAL_DATA_CLIENT_ID,
            clientSecret: GLOBAL_DATA_CLIENT_SECRET
        };
    } else {
        _clientConig = {};
    }
    return _clientConig;
}

final GraphqlClient globalDataClient = check new (GLOBAL_DATA_API_URL,
    config = initClientConfig()
);

# A service representing a network-accessible API
# bound to port `9090`.  
#
@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"]
    }
}
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }

    resource function get evaluations/[int id]() returns Evaluation|error? {

        GetEvaluationsResponse|graphql:ClientError getEvaluationResponse = globalDataClient->getEvaluations(id);
        if (getEvaluationResponse is GetEvaluationsResponse) {
            Evaluation|error evaluation_record = getEvaluationResponse.evaluations.cloneWithType(Evaluation);
            if (evaluation_record is Evaluation) {
                return evaluation_record;

            } else {
                log:printError("Error while processing Application record received", evaluation_record);
                return error("Error while processing Application record received: " + evaluation_record.message() +
                    ":: Detail: " + evaluation_record.detail().toString());
            }

        } else {
            log:printError("Error while creating application", getEvaluationResponse);
            return error("Error while creating application: " + getEvaluationResponse.message() +
                ":: Detail: " + getEvaluationResponse.detail().toString());
        }

    }

    resource function post evaluations(@http:Payload Evaluation[] evaluations) returns json|error {
        json|graphql:ClientError createEvaluationResponse = globalDataClient->createEvaluations(evaluations);
        if (createEvaluationResponse is json) {
            log:printInfo("Evaluations created successfully: " + createEvaluationResponse.toString());
            return createEvaluationResponse;
            // json|error evaluation_record = createEvaluationResponse.evaluations.cloneWithType(json);
            // if(evaluation_record is json) {
            //     return evaluation_record;
            // } else {
            //     log:printError("Error while processing Evaluation record received", evaluation_record);
            //     return error("Error while processing Evaluation record received: " + evaluation_record.message() + 
            //         ":: Detail: " + evaluation_record.detail().toString());
            // }
        } else {
            log:printError("Error while creating evaluation", createEvaluationResponse);
            return error("Error while creating evaluation: " + createEvaluationResponse.message() +
                ":: Detail: " + createEvaluationResponse.detail().toString());
        }

    }

    // resource function post addEvaluation(@http:Payload Evaluation evaluation) returns Evaluation|error? {

    //     AddEvaluationResponse|graphql:ClientError createEvaluationResponse = evaluationClient->addEvaluation(evaluation);
    //     if (createEvaluationResponse is AddEvaluationResponse) {
    //         Evaluation|error evaluation_record = createEvaluationResponse.add_evaluation.cloneWithType(Evaluation);
    //         if (evaluation_record is Evaluation) {
    //             return evaluation_record;

    //         } else {
    //             log:printError("Error while processing Application record received", evaluation_record);
    //             return error("Error while processing Application record received: " + evaluation_record.message() +
    //                 ":: Detail: " + evaluation_record.detail().toString());
    //         }

    //     } else {
    //         log:printError("Error while creating application", createEvaluationResponse);
    //         return error("Error while creating application: " + createEvaluationResponse.message() +
    //             ":: Detail: " + createEvaluationResponse.detail().toString());
    //     }

    // }
}
