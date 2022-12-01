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

    // Removes the specified message from the trash.
    log:printInfo("Untrash a message");

    // ID of the message to untrash.
    string sentMessageId = "<MESSAGE_ID>"; 

    gmail:Message|error untrash = gmailClient->untrashMessage(sentMessageId);

    if (untrash is gmail:Message) {
        log:printInfo("Successfully un-trashed the message");
    } else {
        log:printError("Failed to un-trash the message");
    } 
    log:printInfo("End!");
}
