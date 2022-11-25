import ballerina/log;
import ballerinax/googleapis.classroom;

configurable string clientId = "327689875152-lo474br8lta5878rjhj6n9kas7hv6rup.apps.googleusercontent.com";
configurable string clientSecret = "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";
configurable string refreshUrl = "https://oauth2.googleapis.com/token";
configurable string refreshToken = "1//04SquVuQBatFGCgYIARAAGAQSNwF-L9IrqYnuX5vzwfgfl0IaZlOpV3qwmkKpKiURg0kWCGnyoHZ8rB8ZWm6ebJ9e_J6oECjiEUg";

configurable string assigneeMode = "ALL_STUDENTS";
configurable string id = "539843801333";
// configurable string materials = "null";
// configurable string scheduledTime = "";
// configurable string state = "DRAFT";
configurable string text = "Today Lecture is Canceled";

public function main() returns error? {
    classroom:ConnectionConfig clientconfig = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshUrl: refreshUrl,
            refreshToken: refreshToken
        }
    };
    classroom:Client baseClient = check new (clientconfig);

    classroom:Announcement|error announcement = baseClient->createCoursesAnnouncements(
        
        courseId = id,
        payload =
        {
        id: id,
        assigneeMode: assigneeMode,
        // state: state,
        text: text
    }
    );

    if (announcement is classroom:Announcement) {
        log:printInfo(<string>announcement.id);
    } else {
        log:printInfo(announcement.message());
    }

}
