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

    log:printInfo("Update draft"); // New update will be to update the darft subject, body and attchments.

    // The ID of the draft to update. This will be returned when a draft is created. 
    string createdDraftId = "<DRAFT_ID>";

    gmail:MessageRequest newMessageRequest = {
        recipient : "rahnassalin17@gmail.com",
        sender : "saznyrahnas17@gmail.com",
        messageBody : "Updated Draft Text Message Body",
        subject : "Avinya Foundation",
        contentType : gmail:TEXT_PLAIN
    };

    string testAttachmentPath = "../test_document.txt";
    string attachmentContentType = "text/plain";

    gmail:AttachmentPath[] attachments = [{attachmentPath: testAttachmentPath, mimeType: attachmentContentType}];
    newMessageRequest.attachmentPaths = attachments;

    string|error draftUpdateResponse = gmailClient->updateDraft(createdDraftId, newMessageRequest);
    if (draftUpdateResponse is string) {
        log:printInfo("Successfully updated the draft: ", result = draftUpdateResponse);
    } else {
        log:printError("Failed to update the draft");
    }

    log:printInfo("End!");
}
