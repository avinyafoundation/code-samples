import ballerina/graphql;

public isolated client class GraphqlClient {
    final graphql:Client graphqlClient;
    public isolated function init(string serviceUrl, ConnectionConfig config = {}) returns graphql:ClientError? {
        graphql:ClientConfiguration graphqlClientConfig = {timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                graphqlClientConfig.http1Settings = {...settings};
            }
            if config.cache is graphql:CacheConfig {
                graphqlClientConfig.cache = check config.cache.ensureType(graphql:CacheConfig);
            }
            if config.responseLimits is graphql:ResponseLimitConfigs {
                graphqlClientConfig.responseLimits = check config.responseLimits.ensureType(graphql:ResponseLimitConfigs);
            }
            if config.secureSocket is graphql:ClientSecureSocket {
                graphqlClientConfig.secureSocket = check config.secureSocket.ensureType(graphql:ClientSecureSocket);
            }
            if config.proxy is graphql:ProxyConfig {
                graphqlClientConfig.proxy = check config.proxy.ensureType(graphql:ProxyConfig);
            }
        } on fail var e {
            return <graphql:ClientError>error("GraphQL Client Error", e, body = ());
        }
        graphql:Client clientEp = check new (serviceUrl, graphqlClientConfig);
        self.graphqlClient = clientEp;
    }
    remote isolated function getEvaluations(int eval_id) returns GetEvaluationsResponse|graphql:ClientError {
        string query = string `query getEvaluations($eval_id:Int!) {evaluation(eval_id:$eval_id) {id evaluatee_id evaluator_id evaluation_criteria_id activity_instance_id grade notes response updated}}`;
        map<anydata> variables = {"eval_id": eval_id};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetEvaluationsResponse> check performDataBinding(graphqlResponse, GetEvaluationsResponse);
    }
    remote isolated function getEvaluationsAll() returns GetEvaluationsAllResponse|graphql:ClientError {
        string query = string `query getEvaluationsAll {all_evaluations {id evaluatee_id evaluator_id evaluation_criteria_id activity_instance_id grade notes response updated}}`;
        map<anydata> variables = {};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetEvaluationsAllResponse> check performDataBinding(graphqlResponse, GetEvaluationsAllResponse);
    }
    remote isolated function updateEvaluation(Evaluation evaluation) returns UpdateEvaluationResponse|graphql:ClientError {
        string query = string `mutation updateEvaluation($evaluation:Evaluation!) {update_evaluation(evaluation:$evaluation) {id evaluatee_id evaluator_id evaluation_criteria_id activity_instance_id response notes grade}}`;
        map<anydata> variables = {"evaluation": evaluation};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <UpdateEvaluationResponse> check performDataBinding(graphqlResponse, UpdateEvaluationResponse);
    }
    remote isolated function getMetadata(int meta_evaluation_id) returns GetMetadataResponse|graphql:ClientError {
        string query = string `query getMetadata($meta_evaluation_id:Int!) {evaluation_meta_data(meta_evaluation_id:$meta_evaluation_id) {evaluation_id location on_date_time level meta_type status focus metadata}}`;
        map<anydata> variables = {"meta_evaluation_id": meta_evaluation_id};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetMetadataResponse> check performDataBinding(graphqlResponse, GetMetadataResponse);
    }
    remote isolated function AddEvaluationMetaData(EvaluationMetadata metadata) returns AddEvaluationMetaDataResponse|graphql:ClientError {
        string query = string `mutation AddEvaluationMetaData($metadata:EvaluationMetadata!) {add_evaluation_meta_data(metadata:$metadata) {evaluation_id location on_date_time level meta_type status focus metadata}}`;
        map<anydata> variables = {"metadata": metadata};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <AddEvaluationMetaDataResponse> check performDataBinding(graphqlResponse, AddEvaluationMetaDataResponse);
    }
    remote isolated function AddEvaluationanswerOption(EvaluationCriteriaAnswerOption evaluationAnswer) returns AddEvaluationanswerOptionResponse|graphql:ClientError {
        string query = string `mutation AddEvaluationanswerOption($evaluationAnswer:EvaluationCriteriaAnswerOption!) {add_evaluation_answer_option(evaluationAnswer:$evaluationAnswer) {answer expected_answer evaluation_criteria_id}}`;
        map<anydata> variables = {"evaluationAnswer": evaluationAnswer};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <AddEvaluationanswerOptionResponse> check performDataBinding(graphqlResponse, AddEvaluationanswerOptionResponse);
    }
    remote isolated function GetEvaluationCycle(int id) returns GetEvaluationCycleResponse|graphql:ClientError {
        string query = string `query GetEvaluationCycle($id:Int!) {evaluation_cycle(id:$id) {name description start_date end_date}}`;
        map<anydata> variables = {"id": id};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetEvaluationCycleResponse> check performDataBinding(graphqlResponse, GetEvaluationCycleResponse);
    }
    remote isolated function AddEducationExperience(Evaluation evaluation, EducationExperience education_experience) returns AddEducationExperienceResponse|graphql:ClientError {
        string query = string `mutation AddEducationExperience($education_experience:EducationExperience!,$evaluation:Evaluation!) {add_education_experience(education_experience:$education_experience,evaluation:$evaluation) {person_id school start_date end_date}}`;
        map<anydata> variables = {"evaluation": evaluation, "education_experience": education_experience};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <AddEducationExperienceResponse> check performDataBinding(graphqlResponse, AddEducationExperienceResponse);
    }
    remote isolated function GetEducationExperience(int person_id) returns GetEducationExperienceResponse|graphql:ClientError {
        string query = string `query GetEducationExperience($person_id:Int!) {education_experience(person_id:$person_id) {person_id school start_date end_date}}`;
        map<anydata> variables = {"person_id": person_id};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetEducationExperienceResponse> check performDataBinding(graphqlResponse, GetEducationExperienceResponse);
    }
    remote isolated function GetWorkExperience(int person_id) returns GetWorkExperienceResponse|graphql:ClientError {
        string query = string `query GetWorkExperience($person_id:Int!) {work_experience(person_id:$person_id) {person_id organization start_date end_date}}`;
        map<anydata> variables = {"person_id": person_id};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetWorkExperienceResponse> check performDataBinding(graphqlResponse, GetWorkExperienceResponse);
    }
    remote isolated function AddWorkExperience(Evaluation evaluation, WorkExperience work_experience) returns AddWorkExperienceResponse|graphql:ClientError {
        string query = string `mutation AddWorkExperience($work_experience:WorkExperience!,$evaluation:Evaluation!) {add_work_experience(work_experience:$work_experience,evaluation:$evaluation) {person_id school start_date end_date}}`;
        map<anydata> variables = {"evaluation": evaluation, "work_experience": work_experience};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <AddWorkExperienceResponse> check performDataBinding(graphqlResponse, AddWorkExperienceResponse);
    }
}
