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