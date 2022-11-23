import ballerina/http;

service /event on new http:Listener(8080) {

    isolated resource function get .() returns int|error? {
        return get_events();
    }
    
    isolated resource function get [string id]() returns int|error? {
        return get_event();
    }

    isolated resource function post .() returns int|error? {
        return create_event();
    }

    isolated resource function put .() returns int|error? {
        return update_event();
    }

    isolated resource function delete .() returns int|error? {
        return delete_event();
    }

    isolated resource function get quick() returns int|error? {
        return quick_add_events();
    }
}

service /calendar on new http:Listener(8080) {

    isolated resource function get .() returns int|error? {
        return get_calendar();
    }
    
    isolated resource function post .() returns int|error? {
        return create_calendar();
    }

    isolated resource function delete .() returns int|error? {
        return delete_calendar();
    }
}

