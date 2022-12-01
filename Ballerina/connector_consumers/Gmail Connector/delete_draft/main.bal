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

    log:printInfo("Delete a draft");
    
    // The ID of the existing draft we want to delete.
    string createdDraftId = "<DRAFT_ID>"; 

    error? deleteResponse = gmailClient->deleteDraft(createdDraftId);

    if (deleteResponse is error) {
        log:printError("Failed to delete the draft");
    } else {
        log:printInfo("Successfully deleted the draft");
    }

    log:printInfo("End!");
}