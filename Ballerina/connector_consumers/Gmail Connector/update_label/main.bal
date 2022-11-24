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

    log:printInfo("Update label");
    
    // The ID of an already created label that we want to update
    string createdLabelId = "<Lable ID>";

    string updateName = "updateTest";
    string updateBgColor = "#16a766";
    string updateTxtColor = "#000000";

    gmail:Label|error updateLabelResponse = gmailClient->updateLabel(createdLabelId, name = updateName,
        backgroundColor = updateBgColor, textColor = updateTxtColor);

    if (updateLabelResponse is gmail:Label) {
        log:printInfo("Successfully updated label: ", status = updateLabelResponse.name == updateName &&
                       updateLabelResponse?.color?.backgroundColor == updateBgColor &&
                       updateLabelResponse?.color?.textColor == updateTxtColor);
    } else {
        log:printError("Failed to update label");
    }

    log:printInfo("End!");
}