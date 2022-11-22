import ballerina/log;
import ballerinax/googleapis.calendar;

# Configuration for accessing Google Calendar API.
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

final calendar:ConnectionConfig config = {
    auth: 
        {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
};

calendar:Client calendarClient = check new (config);


##### Calendar Functions #####
# Create Calendar
isolated function create_calendar() returns error? {
   
   calendar:CalendarResource|error res = calendarClient->createCalendar("testCalendar");
   if (res is calendar:CalendarResource) {
      log:printInfo(res.id);
   } else {
      log:printError(res.message());
   }
}

# Delete Calendar
isolated function delete_calendar() returns error?{

    error? res = calendarClient->deleteCalendar(calendarId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:printInfo("Calendar is deleted");
    }
}

# Get Calendar
isolated  function get_calendar() returns error? {

    calendar:CalendarResource|error res = calendarClient->getCalendar(calendarId);
    if (res is calendar:CalendarResource) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}

##### Event Functions #####
# Create Event
isolated function create_event() returns error? {

    calendar:InputEvent event = {
        'start: {
            dateTime:  "2022-02-28T09:00:00+0530"
        },
        end: {
            dateTime:  "2022-02-28T09:00:00+0530"
        },
        summary: "Sample Event"
    };
    calendar:Event|error res = calendarClient->createEvent("primary", event);
    if (res is calendar:Event) {
       log:printInfo(res.id);
    } else {
       log:printError(res.message());
    }
}

# Delete Event
isolated  function delete_event() returns error? {

    error? res = calendarClient->deleteEvent(calendarId, eventId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:printInfo("Event is deleted");
    }
}

# Get Event
isolated  function get_event() returns error? {

    calendar:Event|error res = calendarClient->getEvent(calendarId, eventId);
    if (res is calendar:Event) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}

# Get Events
isolated  function get_events() returns error? {

    stream<calendar:Event,error?> resultStream  = check calendarClient->getEvents("primary");
    record {|calendar:Event value;|}|error? res = resultStream.next();
    if (res is record {|calendar:Event value;|}) {
        log:printInfo(res.value["id"]);
    } else {
        if (res is error) {
            log:printError(res.message());
        }
    }
}

# Quick Add Events
isolated  function quick_add_events() returns error? {

    calendar:Event|error res = calendarClient->quickAddEvent(calendarId, "Sample Event");
    if (res is calendar:Event) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}

# Update Event
isolated function update_event() returns error? {

    calendar:InputEvent event = {
        'start: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        end: {
            dateTime:  "2021-02-28T09:00:00+0530"
        },
        summary: "Sample Event"
    };

    calendar:Event|error res = calendarClient->updateEvent(calendarId, eventId, event);
    if (res is calendar:Event) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}


  