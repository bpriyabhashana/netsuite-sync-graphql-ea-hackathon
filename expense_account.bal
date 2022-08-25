import ballerina/sql;

function getExpenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns ExpenseAccount[]|error {

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
    if filterCriteria.expenseType != () && filterCriteria.expenseType != "" {
        filter.push(<sql:ParameterizedQuery>` mis_flash_section = ${filterCriteria.expenseType}`);
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
            FROM mis_expense`;

    sql:ParameterizedQuery dynamicFilter = ` `;

    if filter.length() > 0 {
        foreach int i in 0 ..< filter.length() {
            dynamicFilter = sql:queryConcat(dynamicFilter, (i == 0) ? ` ` : (` AND `), filter[i]);
        }
        query = sql:queryConcat(query, ` WHERE `, dynamicFilter);
    } else {
        query = query;
    }

    ExpenseAccount[]|error response = runQueryExpenseAccount(query);
    return response;
}

function runQueryExpenseAccount(sql:ParameterizedQuery query) returns ExpenseAccount[]|error {

    stream<ExpenseAccount, error?> resultStream = mysqlClient->query(query);

    ExpenseAccount[]? payload = check
        from ExpenseAccount data in resultStream
    select data;

    return payload ?: [];
}
