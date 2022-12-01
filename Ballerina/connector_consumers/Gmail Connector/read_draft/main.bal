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

    log:printInfo("Read a draft");
    
    // The ID of the existing draft we want to read.
    string createdDraftId = "<DRAFT_ID>"; 

    gmail:Draft|error draftReadResponse = gmailClient->readDraft(createdDraftId);
    if (draftReadResponse is gmail:Draft) {
        log:printInfo("Successfully read the draft: ", status = draftReadResponse.id == createdDraftId);
    } else {
        log:printError("Failed to get draft");
    }

    log:printInfo("End!");
}