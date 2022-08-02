import ballerina/sql;

service class AccountAvailability {
    private final readonly & AvailabilityData data;

    function init(AvailabilityData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get IsAvailable() returns int? {
        return self.data.IsAvailable;
    }

}

# check the availability of the account for month based on DateIdFilterCriteria
# e.g. yearMonth: "2021-02", id: 43
#
# if the query execution succeeded, it returns the AccountAvailability
#
# + filterCriteria - (refer records.bal for more details)  
# + return - AccountAvailability[]|error  

function loadAvailabilityIncomeData(DateIdFilterCriteria filterCriteria) returns AccountAvailability[]|error {

    sql:ParameterizedQuery query = `SELECT trandate = ${filterCriteria.yearMonth} 
            AS IsAvailable
            FROM mis_income
            WHERE id = ${filterCriteria.id}`;

    AccountAvailability[]|error response = runQueryAvailabilityRecord(query);

    return response;
}

function loadAvailabilityExpenseData(DateIdFilterCriteria filterCriteria) returns AccountAvailability[]|error {

    sql:ParameterizedQuery query = `SELECT trandate = ${filterCriteria.yearMonth} 
            AS IsAvailable
            FROM mis_expense
            WHERE id = ${filterCriteria.id}`;

    AccountAvailability[]|error response = runQueryAvailabilityRecord(query);

    return response;
}

function runQueryAvailabilityRecord(sql:ParameterizedQuery query) returns AccountAvailability[]|error {
    AccountAvailability[]? payload = [];

    stream<AvailabilityData, error?> resultStream = mysqlClient->query(query);

    payload = check from AvailabilityData availabilityData in resultStream
        let var accRow = check availabilityData.cloneWithType(AvailabilityData)
        select new AccountAvailability(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}
