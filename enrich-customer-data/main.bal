import ballerina/http;

configurable string geocodingAPIKey = ?;

type Customer record {|
    string customerId;
    string address;
|};

type GeoTaggedCustomer record {|
    *Customer;
    decimal latitude;
    decimal longitude;
|};

type Location record {
    decimal lat;
    decimal lng;
};

type ResultsItem record {
    record {
        Location location;
    } geometry;
};

type GeocodeResponse record {
    ResultsItem[] results;
    string status;
};

final http:Client geocodingClient = check new ("https://maps.googleapis.com");

service /api/v1 on new http:Listener(8080) {
    resource function post customerWithGeoCode(Customer customer) returns GeoTaggedCustomer|error {
        // call the geocode api and retrive the lattiude and longitude information
        GeocodeResponse response = check geocodingClient->
            /maps/api/geocode/'json(address = customer.address, key = geocodingAPIKey);
        if response.status == "OK" {
            // enrich the customer data with location information
            return {
                ...customer,
                latitude: response.results[0].geometry.location.lat,
                longitude: response.results[0].geometry.location.lng
            };
        }
        return error("Error while getting the location information.");
    }
}