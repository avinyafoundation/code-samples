import ballerina/log;
import ballerinax/googleapis.classroom;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = ?;
configurable string refreshToken = ?;

configurable string assigneeMode = "ALL_STUDENTS";
configurable string id = ?;
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
