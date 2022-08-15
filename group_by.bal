import ballerina/sql;
import ballerina/io;
service class GroupExpenseAccount {
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

function getGroupByExpenseAccounts(ExpenseAccountGroupFilterCriteria filterCriteria) returns GroupExpenseAccount[]|error {
 io:println(filterCriteria);


sql:ParameterizedQuery selectQuery = `SELECT `;
sql:ParameterizedQuery groupBy = `GROUP BY `;


 if <boolean>(filterCriteria.groupBy.AccountType) {
      selectQuery = sql:queryConcat(selectQuery, ` account_type AS AccountType,`);
      groupBy = sql:queryConcat(groupBy, ` account_type,`);
    }

if <boolean>(filterCriteria.groupBy.AccountCategory) {
    selectQuery = sql:queryConcat(selectQuery, ` account_category AS AccountCategory,`);
      groupBy = sql:queryConcat(groupBy, ` account_category,`);
    }

    if <boolean>(filterCriteria.groupBy.ExpenseType) {
    selectQuery = sql:queryConcat(selectQuery, ` mis_flash_section AS ExpenseType,`);
      groupBy = sql:queryConcat(groupBy, ` mis_flash_section,`);
    }

    if <boolean>(filterCriteria.groupBy.BusinessUnit) {
         selectQuery = sql:queryConcat(selectQuery, ` business_unit AS BusinessUnit,`);
      groupBy = sql:queryConcat(groupBy, ` business_unit`);
    }

 sql:ParameterizedQuery query = sql:queryConcat(selectQuery, 
            ` SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
                AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS Balance
                FROM mis_expense
                WHERE trandate > SUBSTRING(${filterCriteria.range?.startDate}, 1, 7) AND 
                trandate <= SUBSTRING(${filterCriteria.range?.endDate}, 1, 7) `, groupBy);

    // sql:ParameterizedQuery query = `SELECT account_type AS AccountType, 
    //                account_category AS AccountCategory, 
    //                business_unit AS BusinessUnit, 
    //                SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
    //                AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS Balance
    //                 FROM mis_income
    //                 WHERE trandate > SUBSTRING(${filterCriteria.range?.startDate}, 1, 7) AND 
    //                 trandate <= SUBSTRING(${filterCriteria.range?.endDate}, 1, 7)
    //                 GROUP BY account_type, account_category, business_unit`;

            io:println(query);

             GroupExpenseAccount[]|error response = runQueryGroupExpenseAccounts(query);

    return response;
}

function runQueryGroupExpenseAccounts(sql:ParameterizedQuery query) returns GroupExpenseAccount[]|error {
    GroupExpenseAccount[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(SumOfExpenseAccountData)
        select new GroupExpenseAccount(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}