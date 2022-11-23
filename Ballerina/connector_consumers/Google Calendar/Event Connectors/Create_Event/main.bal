import ballerina/log;
import ballerinax/googleapis.calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = "43v5o118g0f6ioj1mku4t5ugbc@group.calendar.google.com";

public function main() returns error? {

    calendar:ConnectionConfig config = {
       auth: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };
    calendar:Client calendarClient = check new (config);

    calendar:InputEvent event = {
        'start: {
            dateTime:  "2022-11-23T10:00:00+0530"
        },
        end: {
            dateTime:  "2022-11-23T10:00:00+0530"
        },
        summary: "Sample Event1"
    };
    calendar:Event|error res = calendarClient->createEvent(calendarId, event);
    if (res is calendar:Event) {
       log:printInfo(res.id);
    } else {
       log:printError(res.message());
    }
}