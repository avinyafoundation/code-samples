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

    log:printInfo("Send draft");
    
    // The ID of the existing draft we want to send.
    string createdDraftId = "<DRAFT_ID>"; 

    gmail:Message |error sendDraftResponse = gmailClient->sendDraft(createdDraftId);
    
    if (sendDraftResponse is gmail:Message) {
        log:printInfo("Sent the draft successfully: ",
                      status =  sendDraftResponse.id !== "" && sendDraftResponse.threadId !== "");
    } else {
        log:printError("Failed to send the draft");
    }

    log:printInfo("End!");
}