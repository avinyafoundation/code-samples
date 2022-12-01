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

    log:printInfo("Trash and Untrash thread");

    // ID of the thread to trash or untrash.
    string sentMessageThreadId = "<THREAD_ID>"; 

    log:printInfo("Trash thread");
    gmail:MailThread|error trash = gmailClient->trashThread(sentMessageThreadId);

    if (trash is gmail:MailThread) {
        log:printInfo("Successfully trashed the thread");
    } else {
        log:printError("Failed to trash the thread");
    } 



    log:printInfo("Un-trash thread");
    gmail:MailThread|error untrash = gmailClient->untrashThread(sentMessageThreadId);

    if (untrash is gmail:MailThread) {
        log:printInfo("Successfully un-trashed the thread");
    } else {
        log:printError("Failed to un-trash the thread");
    } 
    
    log:printInfo("End!");
}