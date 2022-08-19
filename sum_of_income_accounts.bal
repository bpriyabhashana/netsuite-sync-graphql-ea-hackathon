import ballerina/sql;

service class SumOfIncomeAccount {
    private final readonly & SumOfIncomeAccountData data;

    function init(SumOfIncomeAccountData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get accountType() returns string? {
        return self.data.accountType;
    }

    resource function get accountCategory() returns string? {
        return self.data.accountCategory;
    }

    resource function get incomeType() returns string? {
        return self.data.incomeType;
    }

    resource function get businessUnit() returns string? {
        return self.data.businessUnit;
    }

    resource function get balance() returns decimal? {
        return self.data.balance;
    }

}

function getSumOfIncomeAccounts(IncomeAccountGroupFilterCriteria filterCriteria) returns SumOfIncomeAccount[]|error {

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

    if <boolean>filterCriteria.groupBy.incomeType {
        selectQuery = sql:queryConcat(selectQuery, ` mis_flash_section AS incomeType,`);
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
                FROM mis_income
                WHERE trandate > SUBSTRING(${filterCriteria.range?.startDate}, 1, 7) AND 
                trandate <= SUBSTRING(${filterCriteria.range?.endDate}, 1, 7) `, (groupQuery.length() != 0) ? sql:queryConcat(`GROUP BY`, dynamicFilter) : ` `);

    SumOfIncomeAccount[]|error response = runQueryGroupIncomeAccounts(query);

    return response;
}

function runQueryGroupIncomeAccounts(sql:ParameterizedQuery query) returns SumOfIncomeAccount[]|error {
    SumOfIncomeAccount[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(SumOfIncomeAccountData)
        select new SumOfIncomeAccount(accRow);

    return payload ?: [];
}
