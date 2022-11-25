import ballerina/log;
import ballerinax/googleapis.calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string calendarId = "u01ra5ck1gsnnbd8bh8l8663rs@group.calendar.google.com";

public function main() returns error?{

    calendar:ConnectionConfig config = {
       auth: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };

    calendar:Client calendarClient = check new (config);

    error? res = calendarClient->deleteCalendar(calendarId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:printInfo("Calendar is deleted");
    }
}