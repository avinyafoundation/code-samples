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



    log:printInfo("Send the message");
    gmail:MessageRequest messageRequest = {
        recipient : "rahnassalin17@gmail.com",
        sender : "saznyrahnas17@gmail.com", 
        cc : "srahnas@virtusa.com", 
        subject : "Avinya Foundation",
        messageBody : "Hi, This is a main content",
        contentType : gmail:TEXT_PLAIN
    };

    string testAttachmentPath = "../test_document.txt";
    string attachmentContentType = "text/plain";
    
    // Set Attachments if exists
    gmail:AttachmentPath[] attachments = [{attachmentPath: testAttachmentPath, mimeType: attachmentContentType}];
    messageRequest.attachmentPaths = attachments;

    gmail:Message|error sendMessageResponse = checkpanic gmailClient->sendMessage(messageRequest);
    
    if (sendMessageResponse is gmail:Message) {
        // If successful, print the message ID and thread ID.
        log:printInfo("Sent Message ID: "+ sendMessageResponse.id);
        log:printInfo("Sent Thread ID: "+ sendMessageResponse.threadId);
    } else {
        // If unsuccessful, print the error returned.
        log:printError(sendMessageResponse.message());
    }
    log:printInfo("End!");

}
