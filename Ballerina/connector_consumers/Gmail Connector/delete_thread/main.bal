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

    log:printInfo("Delete thread");

    // ID of the thread to delete.
    string sentMessageThreadId = "<THREAD_ID>"; 

    error? delete = gmailClient->deleteThread(sentMessageThreadId);
 
    if (delete is error) {
        log:printError("Failed to delete the thread");
    } else {
        log:printInfo("Successfully deleted the thread");
    }

    log:printInfo("End!");
}
