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
    
    // Moves the specified message to the trash.
    log:printInfo("Trash a message");

    // ID of the message to trash.
    string sentMessageId = "<MESSAGE_ID>"; 

    gmail:Message|error trash = gmailClient->trashMessage(sentMessageId);

    if (trash is gmail:Message) {
        log:printInfo("Successfully trashed the message");
    } else {
        log:printError("Failed to trash the message");
    }
    log:printInfo("End!");
}
