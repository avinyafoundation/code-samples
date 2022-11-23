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

    log:printInfo("Create draft");
    // The ID of the thread the draft should sent to. this is optional.
    string sentMessageThreadId = "<THREAD_ID>";


    gmail:MessageRequest messageRequest = {
        recipient : "rahnassalin17@gmail.com", 
        sender : "saznyrahnas17@gmail.com", 
        cc : "srahnas@virtusa.com", 
        messageBody : "Draft Text Message Body",
        contentType : gmail:TEXT_PLAIN,
        subject: "Avinya Foundation"};

    string|error draftResponse = gmailClient->createDraft(messageRequest, threadId = sentMessageThreadId);
    
    if (draftResponse is string) {
        log:printInfo("Successfully created draft: ", draftId = draftResponse);
    } else {
        log:printError("Failed to create draft");
    }
    log:printInfo("End!");
}