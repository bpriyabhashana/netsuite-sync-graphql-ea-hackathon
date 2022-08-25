import ballerina/sql;

function getSumOfExpenseAccounts(ExpenseAccountGroupFilterCriteria filterCriteria) returns SumOfExpenseAccount[]|error {

    sql:ParameterizedQuery selectQuery = ` `;
    sql:ParameterizedQuery dynamicFilter = ` `;
    sql:ParameterizedQuery[] groupQuery = [];

    if <boolean>filterCriteria.groupBy.accountType {
        selectQuery = sql:queryConcat(selectQuery, ` account_type AS accountType,`);
        groupQuery.push(<sql:ParameterizedQuery>` account_type`);
    }

    if <boolean>filterCriteria.groupBy.accountCategory {
        selectQuery = sql:queryConcat(selectQuery, ` account_category AS accountCategory,`);
        groupQuery.push(<sql:ParameterizedQuery>` account_category`);
    }

    if <boolean>filterCriteria.groupBy.expenseType {
        selectQuery = sql:queryConcat(selectQuery, ` mis_flash_section AS expenseType,`);
        groupQuery.push(<sql:ParameterizedQuery>` mis_flash_section`);
    }

    if <boolean>filterCriteria.groupBy.businessUnit {
        selectQuery = sql:queryConcat(selectQuery, ` business_unit AS businessUnit,`);
        groupQuery.push(<sql:ParameterizedQuery>` business_unit`);
    }
    foreach int i in 0 ..< groupQuery.length() {
        dynamicFilter = sql:queryConcat(dynamicFilter, (i != groupQuery.length() - 1) ? sql:queryConcat(groupQuery[i], `, `) : groupQuery[i]);
    }

    sql:ParameterizedQuery query = sql:queryConcat(`SELECT `, selectQuery,
                ` SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
                AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS balance
                FROM mis_expense
                WHERE trandate > SUBSTRING(${filterCriteria.range?.startDate}, 1, 7) AND 
                trandate <= SUBSTRING(${filterCriteria.range?.endDate}, 1, 7) `, (groupQuery.length() != 0) ? sql:queryConcat(`GROUP BY`, dynamicFilter) : ` `);

    SumOfExpenseAccount[]|error response = runQueryGroupExpenseAccounts(query);

    return response;
}

function runQueryGroupExpenseAccounts(sql:ParameterizedQuery query) returns SumOfExpenseAccount[]|error {

    stream<SumOfExpenseAccount, error?> resultStream = mysqlClient->query(query);

    SumOfExpenseAccount[]? payload = check
        from SumOfExpenseAccount data in resultStream
    select data;

    return payload ?: [];
}
