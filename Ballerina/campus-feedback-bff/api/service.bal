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

    resource function get evaluation_cycle/[int cycle_id]() returns EvaluationCycle|error {
        GetEvaluationCycleResponse|graphql:ClientError getEvaluationCycleResponse = globalDataClient->GetEvaluationCycle(cycle_id);
        if (getEvaluationCycleResponse is GetEvaluationCycleResponse) {
            EvaluationCycle|error evaluation_cycle_record = getEvaluationCycleResponse.evaluation_cycle.cloneWithType(EvaluationCycle);
            if (evaluation_cycle_record is EvaluationCycle) {
                return evaluation_cycle_record;
            } else {
                log:printError("Error while processing Application record received", evaluation_cycle_record);
                return error("Error while processing Application record received: " + evaluation_cycle_record.message() +
                    ":: Detail: " + evaluation_cycle_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", getEvaluationCycleResponse);
            return error("Error while creating application: " + getEvaluationCycleResponse.message() +
                ":: Detail: " + getEvaluationCycleResponse.detail().toString());
        }
    }

    resource function post add_evaluation_cycle(@http:Payload EvaluationCycle evaluationCycle) returns json|error {
        json|graphql:ClientError addEvaluationCycleResponse = globalDataClient->AddEvaluationCycle(evaluationCycle);
        if (addEvaluationCycleResponse is json) {
            log:printInfo("Evaluation_cycle created successfully: " + addEvaluationCycleResponse.toString());
            return addEvaluationCycleResponse;
            // json|error evaluation_record = createEvaluationResponse.evaluations.cloneWithType(json);
            // if(evaluation_record is json) {
            //     return evaluation_record;
            // } else {
            //     log:printError("Error while processing Evaluation record received", evaluation_record);
            //     return error("Error while processing Evaluation record received: " + evaluation_record.message() + 
            //         ":: Detail: " + evaluation_record.detail().toString());
            // }
        } else {
            log:printError("Error while creating evaluation_cycle", addEvaluationCycleResponse);
            return error("Error while creating evaluation_cycle: " + addEvaluationCycleResponse.message() +
                ":: Detail: " + addEvaluationCycleResponse.detail().toString());
        }
    }

    resource function get education_experience/[int person_id]() returns EducationExperience[]|error {
        GetEducationExperienceResponse|graphql:ClientError getEducationExperienceResponse = globalDataClient->GetEducationExperience(person_id);
        if (getEducationExperienceResponse is GetEducationExperienceResponse) {
            EducationExperience[] educationExperienceAlls = [];
            foreach var educationExperience_All in getEducationExperienceResponse.education_experience_byPerson {
                EducationExperience|error educationExperienceAll = educationExperience_All.cloneWithType(EducationExperience);
                if (educationExperienceAll is EducationExperience) {
                    educationExperienceAlls.push(educationExperienceAll);
                }

                else {
                    log:printError("Error while processing Application record received", educationExperienceAll);
                    return error("Error while processing Application record received: " + educationExperienceAll.message() +
                    ":: Detail: " + educationExperienceAll.detail().toString());
                }
            }
            return educationExperienceAlls;
        }
        else {
            log:printError("Error while creating application", getEducationExperienceResponse);
            return error("Error while creating application: " + getEducationExperienceResponse.message() +
                ":: Detail: " + getEducationExperienceResponse.detail().toString());
        }
    }

    resource function post education_experience(@http:Payload EducationExperience education_experience) returns EducationExperience|error {
        AddEducationExperienceResponse|graphql:ClientError addEducationExperienceResponse = globalDataClient->AddEducationExperience(education_experience);
        if (addEducationExperienceResponse is AddEducationExperienceResponse) {
            EducationExperience|error education_experience_record = addEducationExperienceResponse.add_education_experience.cloneWithType(EducationExperience);
            if (education_experience_record is EducationExperience) {
                return education_experience_record;
            } else {
                log:printError("Error while processing Application record received", education_experience_record);
                return error("Error while processing Application record received: " + education_experience_record.message() +
                    ":: Detail: " + education_experience_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", addEducationExperienceResponse);
            return error("Error while creating application: " + addEducationExperienceResponse.message() +
                ":: Detail: " + addEducationExperienceResponse.detail().toString());
        }
    }

    resource function get work_experience/[int person_id]() returns WorkExperience[]|error {
        GetWorkExperienceResponse|graphql:ClientError getWorkExperienceResponse = globalDataClient->GetWorkExperience(person_id);
        if (getWorkExperienceResponse is GetWorkExperienceResponse) {
            WorkExperience[] workExperienceAlls = [];
            foreach var workExperience_All in getWorkExperienceResponse.work_experience_ByPerson {
                WorkExperience|error workExperienceAll = workExperience_All.cloneWithType(WorkExperience);
                if (workExperienceAll is EducationExperience) {
                    workExperienceAlls.push(workExperienceAll);
                }

                else {
                    log:printError("Error while processing Application record received", workExperienceAll);
                    return error("Error while processing Application record received: " + workExperienceAll.message() +
                    ":: Detail: " + workExperienceAll.detail().toString());
                }
            }
            return workExperienceAlls;
        }
        else {
            log:printError("Error while creating application", getWorkExperienceResponse);
            return error("Error while creating application: " + getWorkExperienceResponse.message() +
                ":: Detail: " + getWorkExperienceResponse.detail().toString());
        }
    }

    resource function post work_experience(@http:Payload WorkExperience work_experience) returns WorkExperience|error {
        AddWorkExperienceResponse|graphql:ClientError addWorkExperienceResponse = globalDataClient->AddWorkExperience(work_experience);
        if (addWorkExperienceResponse is AddWorkExperienceResponse) {
            WorkExperience|error work_experience_record = addWorkExperienceResponse.add_work_experience.cloneWithType(WorkExperience);
            if (work_experience_record is WorkExperience) {
                return work_experience_record;
            } else {
                log:printError("Error while processing Application record received", work_experience_record);
                return error("Error while processing Application record received: " + work_experience_record.message() +
                    ":: Detail: " + work_experience_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", addWorkExperienceResponse);
            return error("Error while creating application: " + addWorkExperienceResponse.message() +
                ":: Detail: " + addWorkExperienceResponse.detail().toString());
        }
    }

    resource function get evaluation_criteria/[int id]/[string prompt]() returns EvaluationCriteria|error {
        GetEvaluationCriteriaResponse|graphql:ClientError getEvaluationCriteriaResponse = globalDataClient->GetEvaluationCriteria(id, prompt);
        if (getEvaluationCriteriaResponse is GetEvaluationCriteriaResponse) {
            EvaluationCriteria|error evaluation_criteria_record = getEvaluationCriteriaResponse.evaluationCriteria.cloneWithType(EvaluationCriteria);
            if (evaluation_criteria_record is EvaluationCriteria) {
                return evaluation_criteria_record;
            } else {
                log:printError("Error while processing Application record received", evaluation_criteria_record);
                return error("Error while processing Application record received: " + evaluation_criteria_record.message() +
                    ":: Detail: " + evaluation_criteria_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", getEvaluationCriteriaResponse);
            return error("Error while creating application: " + getEvaluationCriteriaResponse.message() +
                ":: Detail: " + getEvaluationCriteriaResponse.detail().toString());
        }
    }

    resource function post evaluation_criteria(@http:Payload EvaluationCriteria evaluationCriteria) returns EvaluationCriteria|error {
        AddEvaluationCriteriaResponse|graphql:ClientError addEvaluationCriteriaResponse = globalDataClient->AddEvaluationCriteria(evaluationCriteria);
        if (addEvaluationCriteriaResponse is AddEvaluationCriteriaResponse) {
            EvaluationCriteria|error add_evaluation_criteria_record = addEvaluationCriteriaResponse.add_evaluation_criteria.cloneWithType(EvaluationCriteria);
            if (add_evaluation_criteria_record is EvaluationCriteria) {
                return add_evaluation_criteria_record;
            } else {
                log:printError("Error while processing Application record received", add_evaluation_criteria_record);
                return error("Error while processing Application record received: " + add_evaluation_criteria_record.message() +
                    ":: Detail: " + add_evaluation_criteria_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", addEvaluationCriteriaResponse);
            return error("Error while creating application: " + addEvaluationCriteriaResponse.message() +
                ":: Detail: " + addEvaluationCriteriaResponse.detail().toString());
        }
    }

    resource function post evaluation_answer_option(@http:Payload EvaluationCriteriaAnswerOption evaluationanswerOption) returns EvaluationCriteriaAnswerOption|error {
        AddEvaluationanswerOptionResponse|graphql:ClientError addEvaluationanswerOptionResponse = globalDataClient->AddEvaluationanswerOption(evaluationanswerOption);
        if (addEvaluationanswerOptionResponse is AddEvaluationanswerOptionResponse) {
            EvaluationCriteriaAnswerOption|error evaluation_criteria_answer_record = addEvaluationanswerOptionResponse.add_evaluation_answer_option.cloneWithType(EvaluationCriteriaAnswerOption);
            if (evaluation_criteria_answer_record is EvaluationCriteriaAnswerOption) {
                return evaluation_criteria_answer_record;
            } else {
                log:printError("Error while processing Application record received", evaluation_criteria_answer_record);
                return error("Error while processing Application record received: " + evaluation_criteria_answer_record.message() +
                    ":: Detail: " + evaluation_criteria_answer_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", addEvaluationanswerOptionResponse);
            return error("Error while creating application: " + addEvaluationanswerOptionResponse.message() +
                ":: Detail: " + addEvaluationanswerOptionResponse.detail().toString());
        }
    }

    resource function post avinya_types(@http:Payload AvinyaType avinyaType) returns AvinyaType|error {
        CreateAvinyaTypeResponse|graphql:ClientError createAvinyaTypeResponse = globalDataClient->createAvinyaType(avinyaType);
        if (createAvinyaTypeResponse is CreateAvinyaTypeResponse) {
            AvinyaType|error avinya_type_record = createAvinyaTypeResponse.add_avinya_type.cloneWithType(AvinyaType);
            if (avinya_type_record is AvinyaType) {
                return avinya_type_record;
            } else {
                log:printError("Error while processing Application record received", avinya_type_record);
                return error("Error while processing Application record received: " + avinya_type_record.message() +
                    ":: Detail: " + avinya_type_record.detail().toString());
            }
        } else {
            log:printError("Error while creating application", createAvinyaTypeResponse);
            return error("Error while creating application: " + createAvinyaTypeResponse.message() +
                ":: Detail: " + createAvinyaTypeResponse.detail().toString());
        }
    }
}
