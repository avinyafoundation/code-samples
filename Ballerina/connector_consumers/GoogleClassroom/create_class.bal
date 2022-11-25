// import ballerina/log;
// import ballerinax/googleapis.classroom;

// configurable string clientId = "327689875152-lo474br8lta5878rjhj6n9kas7hv6rup.apps.googleusercontent.com";
// configurable string clientSecret = "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";
// configurable string refreshUrl = "https://oauth2.googleapis.com/token";
// configurable string refreshToken = "1//04SquVuQBatFGCgYIARAAGAQSNwF-L9IrqYnuX5vzwfgfl0IaZlOpV3qwmkKpKiURg0kWCGnyoHZ8rB8ZWm6ebJ9e_J6oECjiEUg";

// configurable string ownerId = "niroshan95hashitha@gmail.com";
// configurable string name = "History Class";
// configurable string section = "Grade 9";

// public function main() returns error? {
//     classroom:ConnectionConfig clientconfig = {
//         auth: {
//             clientId: clientId,
//             clientSecret: clientSecret,
//             refreshUrl: refreshUrl,
//             refreshToken: refreshToken

//         }

//     };
//     classroom:Client baseClient = check new (clientconfig);

//     classroom:Course|error res = baseClient->createCourses(payload = {
//         ownerId: ownerId,
//         name: name,
//         section: section

//     });
//     if (res is classroom:Course) {
//         log:printInfo(<string>res.id);
//     } else {
//         log:printInfo(res.message());
//     }

// }
