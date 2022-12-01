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

    log:printInfo("List all messages");
    string[] labelsToMatch = ["INBOX"];

    // To exclude messages from spam and trash make set includeSpamTrash to false. Only return messages with labels that 
    // match all of the specified label ID "INBOX"
    gmail:MsgSearchFilter searchFilter = {includeSpamTrash: false, labelIds: labelsToMatch};
    
    stream<gmail:Message,error?>|error msgList = gmailClient->listMessages(filter = searchFilter);

    if (msgList is stream<gmail:Message,error?>) {
        error? e  = msgList.forEach(function (gmail:Message message) {
            log:printInfo(message.toString());
        });
    } else {
        log:printError("Failed to list messages");
    }
    log:printInfo("End!");
}