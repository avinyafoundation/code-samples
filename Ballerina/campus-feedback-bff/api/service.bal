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

    resource function get evaluation/[int eval_id]() returns Evaluation|error? {

        GetEvaluationsResponse|graphql:ClientError getEvaluationResponse = globalDataClient->getEvaluations(eval_id);
        if (getEvaluationResponse is GetEvaluationsResponse) {
            Evaluation|error evaluation_record = getEvaluationResponse.evaluation.cloneWithType(Evaluation);
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

    resource function get all_evaluations() returns Evaluation[]|error? {

        GetEvaluationsAllResponse|graphql:ClientError getEvaluationsAllResponse = globalDataClient->getEvaluationsAll();
        if (getEvaluationsAllResponse is GetEvaluationsAllResponse) {

            Evaluation[] evaluationsAlls = [];
            foreach var evaluations_All in getEvaluationsAllResponse.all_evaluations {
                Evaluation|error evaluationAll = evaluations_All.cloneWithType(Evaluation);
                if (evaluationAll is Evaluation) {
                    evaluationsAlls.push(evaluationAll);
                }
                else {
                    log:printError("Error while processing Application record received", evaluationAll);
                    return error("Error while processing Application record received: " + evaluationAll.message() +
                    ":: Detail: " + evaluationAll.detail().toString());
                }

            }
            return evaluationsAlls;
        }
        else {
            log:printError("Error while getting application", getEvaluationsAllResponse);
            return error("Error while getting application: " + getEvaluationsAllResponse.message() +
                ":: Detail: " + getEvaluationsAllResponse.detail().toString());
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

    resource function get evaluation_meta_data/[int metadata_id]() returns EvaluationMetadata|error {
        GetMetadataResponse|graphql:ClientError getMetadataResponse = globalDataClient->getMetadata(metadata_id);
        if (getMetadataResponse is GetMetadataResponse) {
            EvaluationMetadata|error metadata_record = getMetadataResponse.evaluation_meta_data.cloneWithType(EvaluationMetadata);
            if (metadata_record is EvaluationMetadata) {
                return metadata_record;
            } else {
                log:printError("Error while processing Application record received", metadata_record);
                return error("Error while processing Application record received: " + metadata_record.message() +
                    ":: Detail: " + metadata_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", getMetadataResponse);
            return error("Error while creating application: " + getMetadataResponse.message() +
                ":: Detail: " + getMetadataResponse.detail().toString());
        }
    }

    resource function post add_evaluation_meta_data(@http:Payload EvaluationMetadata metadata) returns EvaluationMetadata|error {
        AddEvaluationMetaDataResponse|graphql:ClientError addEvaluationMetaDataResponse = globalDataClient->AddEvaluationMetaData(metadata);
        if (addEvaluationMetaDataResponse is AddEvaluationMetaDataResponse) {
            EvaluationMetadata|error metadata_record = addEvaluationMetaDataResponse.metadata.cloneWithType(EvaluationMetadata);
            if (metadata_record is EvaluationMetadata) {
                return metadata_record;
            } else {
                log:printError("Error while processing Application record received", metadata_record);
                return error("Error while processing Application record received: " + metadata_record.message() +
                    ":: Detail: " + metadata_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", addEvaluationMetaDataResponse);
            return error("Error while creating application: " + addEvaluationMetaDataResponse.message() +
                ":: Detail: " + addEvaluationMetaDataResponse.detail().toString());
        }
    }

    // resource function get avinya_types() returns AvinyaType[]|error {
    //     GetAvinyaTypesResponse|graphql:ClientError getAvinyaTypesResponse = globalDataClient->getAvinyaTypes();
    //     if (getAvinyaTypesResponse is GetAvinyaTypesResponse) {
    //         AvinyaType[] avinyaTypes = [];
    //         foreach var avinya_type in getAvinyaTypesResponse.avinya_types {
    //             AvinyaType|error avinyaType = avinya_type.cloneWithType(AvinyaType);
    //             if (avinyaType is AvinyaType) {
    //                 avinyaTypes.push(avinyaType);
    //             } else {
    //                 log:printError("Error while processing Application record received", avinyaType);
    //                 return error("Error while processing Application record received: " + avinyaType.message() +
    //                     ":: Detail: " + avinyaType.detail().toString());
    //             }
    //         }

    //         return avinyaTypes;

    //     } else {
    //         log:printError("Error while getting application", getAvinyaTypesResponse);
    //         return error("Error while getting application: " + getAvinyaTypesResponse.message() +
    //             ":: Detail: " + getAvinyaTypesResponse.detail().toString());
    //     }
    // }
}
