// import ballerina/log;
// import ballerinax/googleapis.classroom;

// configurable string clientId = ?;
// configurable string clientSecret = ?;
// configurable string refreshUrl = ?;
// configurable string refreshToken = ?;

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

//     classroom:ListCoursesResponse|error res = baseClient->listCourses();
//     if (res is classroom:ListCoursesResponse) {
//         log:printInfo(res.toString());
//     } else {
//         log:printInfo(res.message());
//     }
// }
