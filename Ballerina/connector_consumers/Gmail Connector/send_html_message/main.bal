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

    log:printInfo("Send a HTML message");

    string inlineImageName = "test_image.png";
    string htmlBody = "<h1> Email Test HTML Body </h1> <br/> <img src=\"cid:image-" + inlineImageName + "\">";
    gmail:MessageRequest messageRequest = {
        recipient : "rahnassalin17@gmail.com", 
        sender : "saznyrahnas17@gmail.com",
        cc : "srahnas@virtusa.com", 
        subject : "HTML-Email-Subject",
        //---Set HTML Body---    
        messageBody : htmlBody,
        contentType : gmail:TEXT_HTML
    };
    
    string inlineImagePath = "../test_image.png";
    string imageContentType = "image/png";
    string testAttachmentPath = "../test_document.txt";
    string attachmentContentType = "text/plain";

    // Set Inline Images if exists
    gmail:InlineImagePath[] inlineImages = [{imagePath: inlineImagePath, mimeType: imageContentType}];
    messageRequest.inlineImagePaths = inlineImages;

    // Set Attachments if exists
    gmail:AttachmentPath[] attachments = [{attachmentPath: testAttachmentPath, mimeType: attachmentContentType}];
    messageRequest.attachmentPaths = attachments;

    gmail:Message|error sendMessageResponse = gmailClient->sendMessage(messageRequest);

    if (sendMessageResponse is gmail:Message) {
        // If successful, print the message ID and thread ID.
        log:printInfo("Sent Message ID: " + sendMessageResponse.id);
        log:printInfo("Sent Thread ID: " + sendMessageResponse.threadId);
    } else {
        // If unsuccessful, print the error returned.
        log:printError("Error: ", 'error = sendMessageResponse);
    }
    log:printInfo("End!");
}