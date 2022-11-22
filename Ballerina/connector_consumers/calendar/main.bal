import ballerina/log;
import ballerinax/googleapis.calendar;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

isolated function create_calendar() returns error? {

   calendar:ConnectionConfig config = {
      auth: {
         clientId: clientId,
         clientSecret: clientSecret,
         refreshToken: refreshToken,
         refreshUrl: refreshUrl
      }
   };
   calendar:Client calendarClient = check new (config);

   calendar:CalendarResource|error res = calendarClient->createCalendar("testCalendar");
   if (res is calendar:CalendarResource) {
      log:printInfo(res.id);
   } else {
      log:printError(res.message());
   }
}

isolated function create_event() returns error? {

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

isolated function delete_calendar() returns error?{

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

isolated  function delete_event() returns error? {

    calendar:ConnectionConfig config = {
       auth: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };

    calendar:Client calendarClient = check new (config);

    error? res = calendarClient->deleteEvent(calendarId, eventId);
    if (res is error) {
        log:printError(res.message());
    } else {
        log:printInfo("Event is deleted");
    }
}

isolated  function get_calendar() returns error? {

    calendar:ConnectionConfig config = {
       auth: {
           clientId: clientId,
           clientSecret: clientSecret,
           refreshToken: refreshToken,
           refreshUrl: refreshUrl
       }
    };

    calendar:Client calendarClient = check new (config);

    calendar:CalendarResource|error res = calendarClient->getCalendar(calendarId);
    if (res is calendar:CalendarResource) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}

isolated  function get_event() returns error? {
  
    calendar:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };
    calendar:Client calendarClient = check new (config);

    calendar:Event|error res = calendarClient->getEvent(calendarId, eventId);
    if (res is calendar:Event) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}

isolated  function get_events() returns error? {

    calendar:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = check new (config);

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

isolated  function quick_add_events() returns error? {

    calendar:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            refreshUrl: refreshUrl
        }
    };

    calendar:Client calendarClient = check new (config);

    calendar:Event|error res = calendarClient->quickAddEvent(calendarId, "Sample Event");
    if (res is calendar:Event) {
        log:printInfo(res.id);
    } else {
        log:printError(res.message());
    }
}

isolated function update_event() returns error? {

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


  