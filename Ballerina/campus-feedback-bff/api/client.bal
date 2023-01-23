
import ballerina/graphql;
import ballerina/log;

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

    remote isolated function getEvaluations(int id) returns GetEvaluationsResponse|graphql:ClientError {
        string query = string `query getEvaluations($id:Int!) {evaluation(eval_id:$id) {id evaluatee_id evaluator_id evaluation_criteria_id activity_instance_id grade notes response updated}}`;
        map<anydata> variables = {"id": id};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetEvaluationsResponse>check performDataBinding(graphqlResponse, GetEvaluationsResponse);
    }

    remote isolated function createEvaluations(Evaluation[] evaluations) returns json|graphql:ClientError {
        string query = string `mutation createEvaluations($evaluations: [Evaluation!]!)
                                {
                                    add_evaluations(evaluations:$evaluations) 
                                        
                                }`;
        map<anydata> variables = {"evaluations": evaluations};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        log:printInfo("Response: " + graphqlResponse.toString());
        return graphqlResponse;
    }

    remote isolated function getEvaluationsAll() returns GetEvaluationsAllResponse|graphql:ClientError {
        string query = string `query getEvaluationsAll {all_evaluations {id evaluatee_id evaluator_id evaluation_criteria_id activity_instance_id grade notes response updated}}`;
        map<anydata> variables = {};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetEvaluationsAllResponse>check performDataBinding(graphqlResponse, GetEvaluationsAllResponse);
    }

    remote isolated function getAvinyaTypes() returns GetAvinyaTypesResponse|graphql:ClientError {
        string query = string `query getAvinyaTypes {avinya_types {id active name global_type foundation_type focus level description}}`;
        map<anydata> variables = {};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <GetAvinyaTypesResponse>check performDataBinding(graphqlResponse, GetAvinyaTypesResponse);
    }

    remote isolated function updateEvaluation(Evaluation evaluation) returns UpdateEvaluationResponse|graphql:ClientError {
        string query = string `mutation updateEvaluation($evaluation:Evaluation!) {update_evaluation(evaluation:$evaluation) {id evaluatee_id evaluator_id evaluation_criteria_id activity_instance_id response notes grade}}`;
        map<anydata> variables = {"evaluation": evaluation};
        json graphqlResponse = check self.graphqlClient->executeWithType(query, variables);
        return <UpdateEvaluationResponse> check performDataBinding(graphqlResponse, UpdateEvaluationResponse);
    }
}
