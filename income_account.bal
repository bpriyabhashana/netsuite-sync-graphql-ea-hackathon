import ballerina/sql;

service class IncomeAccount {
    private final readonly & IncomeAccountData data;

    function init(IncomeAccountData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get id() returns int? {
        return self.data.id;
    }

    resource function get accountName() returns string? {
        return self.data.accountName;
    }

    resource function get comment() returns string? {
        return self.data.comment;
    }

    resource function get month() returns string? {
        return self.data.month;
    }

    resource function get budgetedValue() returns decimal? {
        return self.data.budgetedValue;
    }

    resource function get amount() returns decimal? {
        return self.data.amount;
    }

}

function getIncomeAccount(IncomeAccountFilterCriteria filterCriteria) returns IncomeAccount[]|error {

    sql:ParameterizedQuery[] filter = [];

    if filterCriteria.id != () && filterCriteria.id != () {
        filter.push(<sql:ParameterizedQuery>` id = ${filterCriteria.id}`);
    }
    if filterCriteria.accountCategory != () && filterCriteria.accountCategory != "" {
        filter.push(<sql:ParameterizedQuery>` account_category = ${filterCriteria.accountCategory}`);
    }
    if filterCriteria.businessUnit != () && filterCriteria.businessUnit != "" {
        filter.push(<sql:ParameterizedQuery>` business_unit = ${filterCriteria.businessUnit}`);
    }
    if filterCriteria.range != () && filterCriteria.range is DatePeriodFilterCriteria {
        filter.push(<sql:ParameterizedQuery>` trandate > SUBSTRING(${filterCriteria.range?.startDate}, 1, 7) AND 
                  trandate <= SUBSTRING(${filterCriteria.range?.endDate}, 1, 7)`);
    } else if filterCriteria.month != () && filterCriteria.month != "" {
        filter.push(<sql:ParameterizedQuery>` trandate = ${filterCriteria.month}`);
    }

    sql:ParameterizedQuery query = `SELECT id AS id, 
            account AS accountName, 
            amount AS amount, 
            mis_updated_value AS budgetedValue, 
            comment AS comment,
            tranDate AS month
            FROM mis_income`;

    sql:ParameterizedQuery dynamicFilter = ` `;

    if filter.length() > 0 {
        foreach int i in 0 ..< filter.length() {
            dynamicFilter = sql:queryConcat(dynamicFilter, (i == 0) ? ` ` : (` AND `), filter[i]);
        }
        query = sql:queryConcat(query, ` WHERE `, dynamicFilter);
    } else {
        query = query;
    }

    IncomeAccount[]|error response = runQueryIncomeAccount(query);
    return response;
}

function runQueryIncomeAccount(sql:ParameterizedQuery query) returns IncomeAccount[]|error {
    IncomeAccount[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(IncomeAccountData)
        select new IncomeAccount(accRow);

    return payload ?: [];
}
