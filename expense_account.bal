import ballerina/sql;

service class ExpenseAccount {
    private final readonly & ExpenseAccountData data;

    function init(ExpenseAccountData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get Id() returns int? {
        return self.data.Id;
    }

    resource function get AccountName() returns string? {
        return self.data.AccountName;
    }

    resource function get Comment() returns string? {
        return self.data.Comment;
    }

    resource function get Month() returns string? {
        return self.data.Month;
    }

    resource function get BudgetedValue() returns decimal? {
        return self.data.BudgetedValue;
    }

    resource function get Amount() returns decimal? {
        return self.data.Amount;
    }

}

function getExpenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns ExpenseAccount[]|error {

    sql:ParameterizedQuery[] filter = [];

    if (filterCriteria.accountCategory != ()) {
        filter.push(<sql:ParameterizedQuery>` account_category = ${filterCriteria.accountCategory}`);
    }
    if (filterCriteria.businessUnit != ()) {
        filter.push(<sql:ParameterizedQuery>` business_unit = ${filterCriteria.businessUnit}`);
    }
    if (filterCriteria.expenseType != ()) {
        filter.push(<sql:ParameterizedQuery>` mis_flash_section = ${filterCriteria.expenseType}`);
    }
    if (filterCriteria.range != () && filterCriteria.range is DatePeriodFilterCriteria) {
        filter.push(<sql:ParameterizedQuery>` trandate > SUBSTRING(${filterCriteria.range?.startDate}, 1, 7) AND 
                  trandate <= SUBSTRING(${filterCriteria.range?.endDate}, 1, 7)`);
    } else if (filterCriteria.month != ()) {
        filter.push(<sql:ParameterizedQuery>` trandate = ${filterCriteria.month}`);
    }

    sql:ParameterizedQuery query = `SELECT id AS Id, 
            account AS AccountName, 
            amount as Amount, 
            mis_updated_value AS BudgetedValue, 
            comment AS Comment,
            tranDate AS Month
            FROM mis_expense`;

    sql:ParameterizedQuery dynamicFilter = ` `;

    if (filter.length() > 0) {
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
    ExpenseAccount[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(ExpenseAccountData)
        select new ExpenseAccount(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}
