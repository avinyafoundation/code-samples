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

    log:printInfo("Trash and Untrash thread");

    // ID of the thread to trash or untrash.
    string sentMessageThreadId = "184a334936495a1c"; 

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