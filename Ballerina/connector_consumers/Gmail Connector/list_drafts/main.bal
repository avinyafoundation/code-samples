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

    log:printInfo("List drafts");
    // The user's email address. The special value **me** can be used to indicate the authenticated user.
    string userId = "me";

    gmail:DraftSearchFilter searchFilter = {includeSpamTrash: false, maxResults: 10};
    
    stream<gmail:Draft,error?>|error msgList = gmailClient->listDrafts(filter = searchFilter, userId = userId);
    if (msgList is stream<gmail:Draft,error?>) {
        error? e = msgList.forEach(function (gmail:Draft draft) {
            log:printInfo(draft.toString());
        });   
    } else {
        log:printError("Failed to list drafts");
    }

    log:printInfo("End!");
}