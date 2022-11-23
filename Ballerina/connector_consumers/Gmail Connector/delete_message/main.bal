import ballerinax/googleapis.gmail;
import ballerina/log;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = ?;
configurable string refreshToken = ?;


public function main() returns error? {
    
    gmail:ConnectionConfig gmailConfig = {
    auth: {
        clientId: clientId,
        clientSecret: clientSecret,
        refreshUrl: refreshUrl,
        refreshToken: refreshToken
        }
    };

    gmail:Client gmailClient = check new(gmailConfig);

    // This method immediately and permanently deletes the specified message
    log:printInfo("Delete a message");

    
    // Id of the message to delete. This can be obtained from the response of create message.
    string sentMessageId = "<MESSAGE_ID>"; 

    error? delete = gmailClient->deleteMessage(sentMessageId);
    
    if (delete is error) {
        log:printError("Failed to delete the message");
    } else {
        log:printInfo("Successfully deleted the message");
    }
    log:printInfo("End!");
}
