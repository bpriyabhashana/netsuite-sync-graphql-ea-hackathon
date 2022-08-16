import ballerina/sql;

service class SumOfExpenseAccount {
    private final readonly & SumOfExpenseAccountData data;

    function init(SumOfExpenseAccountData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get AccountType() returns string? {
        return self.data.AccountType;
    }

    resource function get AccountCategory() returns string? {
        return self.data.AccountCategory;
    }

    resource function get ExpenseType() returns string? {
        return self.data.ExpenseType;
    }

    resource function get BusinessUnit() returns string? {
        return self.data.BusinessUnit;
    }

    resource function get Balance() returns decimal? {
        return self.data.Balance;
    }

}

function getSumOfExpenseAccounts(ExpenseAccountGroupFilterCriteria filterCriteria) returns SumOfExpenseAccount[]|error {

    sql:ParameterizedQuery selectQuery = ` `;
    sql:ParameterizedQuery dynamicFilter = ` `;
    sql:ParameterizedQuery[] groupQuery = [];

    if <boolean>filterCriteria.groupBy.AccountType {
        selectQuery = sql:queryConcat(selectQuery, ` account_type AS AccountType,`);
        groupQuery.push(<sql:ParameterizedQuery>` account_type`);
    }

    if <boolean>filterCriteria.groupBy.AccountCategory {
        selectQuery = sql:queryConcat(selectQuery, ` account_category AS AccountCategory,`);
        groupQuery.push(<sql:ParameterizedQuery>` account_category`);
    }

    if <boolean>filterCriteria.groupBy.ExpenseType {
        selectQuery = sql:queryConcat(selectQuery, ` mis_flash_section AS ExpenseType,`);
        groupQuery.push(<sql:ParameterizedQuery>` mis_flash_section`);
    }

    if <boolean>filterCriteria.groupBy.BusinessUnit {
        selectQuery = sql:queryConcat(selectQuery, ` business_unit AS BusinessUnit,`);
        groupQuery.push(<sql:ParameterizedQuery>` business_unit`);
    }
    foreach int i in 0 ..< groupQuery.length() {
        dynamicFilter = sql:queryConcat(dynamicFilter, (i != groupQuery.length() - 1) ? sql:queryConcat(groupQuery[i], `, `) : groupQuery[i]);
    }

    sql:ParameterizedQuery query = sql:queryConcat(`SELECT `, selectQuery,
                ` SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
                AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS Balance
                FROM mis_expense
                WHERE trandate > SUBSTRING(${filterCriteria.range?.startDate}, 1, 7) AND 
                trandate <= SUBSTRING(${filterCriteria.range?.endDate}, 1, 7) `, (groupQuery.length() != 0) ? sql:queryConcat(`GROUP BY`, dynamicFilter) : ` `);

    SumOfExpenseAccount[]|error response = runQueryGroupExpenseAccounts(query);

    return response;
}

function runQueryGroupExpenseAccounts(sql:ParameterizedQuery query) returns SumOfExpenseAccount[]|error {
    SumOfExpenseAccount[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(SumOfExpenseAccountData)
        select new SumOfExpenseAccount(accRow);

    if payload is () {
        return [];
    }
    return payload;
}
