import load_data_from_csv.leads;

import ballerina/io;
import ballerina/uuid;

public type LeadAnalyticsData record {|
    string LeadID;
    string FirstName;
    string LastName;
    string Email;
    string Phone;
    string Company;
    string Status;
    string Source;
    float LeadScore;
    string LeadOwner;
    string LeadCreatedDate;
    string LastContactDate;
    string LastActivity;
    string Converted;
    string ConversionDate;
    float OpportunityAmount;
    string OpportunityStage;
|};

final leads:Client leadsDbClient = check new;

public function main() returns error? {
    LeadAnalyticsData[] leadsData = check io:fileReadCsv("./resources/leads_data.csv");
    leads:LeadAnalyticsDataInsert[] insertData = from var lead in leadsData
        select {id: uuid:createType1AsString(), ...lead};
    _ = check leadsDbClient->/leadanalyticsdata.post(insertData);
}
