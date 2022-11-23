import ballerinax/googleapis.gmail;
import ballerina/log;

configurable string clientId = "54220665783-dl8rdb15aedc0aj0dv9lon9kckaf8ou9.apps.googleusercontent.com";
configurable string clientSecret = "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";
configurable string refreshUrl = "https://oauth2.googleapis.com/token";
configurable string refreshToken = "1//04xQST4jaXT70CgYIARAAGAQSNwF-L9IrYFgV9tehP8HGUL6-TjBYSICX_PPKpfYFJX2DGZwFOIXPheW5E784LQhsXvwFYUkqO3o";

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