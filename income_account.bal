import ballerina/sql;

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

    sql:ParameterizedQuery query = `SELECT id, 
            account AS accountName, 
            amount, 
            mis_updated_value AS budgetedValue, 
            comment,
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

    return runQueryIncomeAccount(query);
}

function runQueryIncomeAccount(sql:ParameterizedQuery query) returns IncomeAccount[]|error {

    stream<IncomeAccount, error?> resultStream = mysqlClient->query(query);

    IncomeAccount[]? payload = check
        from IncomeAccount data in resultStream
    select data;

    return payload ?: [];
}
