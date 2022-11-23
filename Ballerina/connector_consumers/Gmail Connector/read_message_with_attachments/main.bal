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

    log:printInfo("Read a message with an attachment");

    // ID of the message to read with an attachment.
    string sentMessageId = "184a3e6a9677cb8b"; 

    gmail:Message|error response = gmailClient->readMessage(sentMessageId);
    
    if (response is gmail:Message) {
       if (response?.msgAttachments is gmail:MessageBodyPart[] ) {
            log:printInfo("Attachment retrieved " + (<gmail:MessageBodyPart[]>response?.msgAttachments).toString());
       } else {
            log:printError("No attachment exists for this message");
       }
    } else {
        log:printError("Failed to get attachments");
    }
    log:printInfo("End!");
}