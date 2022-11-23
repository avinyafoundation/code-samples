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

    log:printInfo("Modify labels in a thread");
    // ID of the thread to modify.
    string sentMessageThreadId = "184a34d2346fe80c";

    // Modify labels of the thread with thread id which was sent in testSendTextMessage
    log:printInfo("Add labels to a thread");
    gmail:MailThread|error response = gmailClient->modifyThread(sentMessageThreadId, ["INBOX"], []);

    if (response is gmail:MailThread) {
        log:printInfo("Add labels to thread successfully: ", status = response.id == sentMessageThreadId);
    } else {
        log:printInfo("Failed to modify thread");
    }

    log:printInfo("Remove labels from a thread");
    response = gmailClient->modifyThread(sentMessageThreadId, [], ["INBOX"]);
    
    if (response is gmail:MailThread) {
        log:printInfo("Removed labels from thread successfully: ", status = response.id == sentMessageThreadId);
    } else {
        log:printInfo("Failed to modify thread");
    }

    log:printInfo("End!");
}