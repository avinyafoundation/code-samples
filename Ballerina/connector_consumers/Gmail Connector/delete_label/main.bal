import ballerinax/googleapis.gmail;
import ballerina/log;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = ?;
configurable string refreshToken = ?;


public function main() returns error?{
    
    gmail:ConnectionConfig gmailConfig = {
    auth: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshUrl: refreshUrl,
        refreshToken: refreshToken
        }
    };
    gmail:Client gmailClient = check new(gmailConfig);

    log:printInfo("Delete label");
    
    // The ID of an already created label that we want to delete
    string createdLabelId = "<LABEL_ID>";

    error? deleteLabelResponse = gmailClient->deleteLabel(createdLabelId);
     
    if (deleteLabelResponse is error) {
        log:printInfo("Failed to delete the message");
    } else {
        log:printError("Successfully deleted the message");
    }

    log:printInfo("End!");
}