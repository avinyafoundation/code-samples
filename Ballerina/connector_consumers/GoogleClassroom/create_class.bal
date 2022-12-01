import ballerina/log;
import ballerinax/googleapis.classroom;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshUrl = ?;
configurable string refreshToken = ?;

configurable string ownerId = ?;
configurable string name = ?;
configurable string section = ?;

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

    classroom:Course|error res = baseClient->createCourses(payload = {
        ownerId: ownerId,
        name: name,
        section: section

    });
    if (res is classroom:Course) {
        log:printInfo(<string>res.id);
    } else {
        log:printInfo(res.message());
    }

}
