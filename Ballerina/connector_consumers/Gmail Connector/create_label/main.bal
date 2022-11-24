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

    log:printInfo("Create label");
    string displayName = "Test";
    string labelVisibility = "labelShow";
    string messageListVisibility = "show";

    gmail:Label|error createLabelResponse = gmailClient->createLabel(displayName, labelVisibility, messageListVisibility);
    
    if (createLabelResponse is gmail:Label) {
        log:printInfo("Successfully created label: ", labelId = createLabelResponse);
    } else {
        log:printError("Failed to create label");
    }
    
    log:printInfo("End!");
}