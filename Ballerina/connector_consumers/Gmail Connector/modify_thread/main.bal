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

    log:printInfo("Modify labels in a thread");
    // ID of the thread to modify.
    string sentMessageThreadId = "<THREAD_ID>";

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