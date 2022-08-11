import ballerina/sql;

service class Account {
    private final readonly & AccountData data;

    function init(AccountData data) {
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

    resource function get BudgetedValue() returns decimal? {
        return self.data.BudgetedValue;
    }

    resource function get Amount() returns decimal? {
        return self.data.Amount;
    }

}

function getIncomeAccount(IncomeAccountFilterCriteria filterCriteria) returns Account[]|error {

    sql:ParameterizedQuery query = `SELECT id AS Id, 
            account AS AccountName, 
            amount as Amount, 
            mis_updated_value AS BudgetedValue, 
            comment AS Comment
            FROM mis_income
            WHERE account_type = 'Income' AND
                  account_category = ${filterCriteria.accountCategory} AND
                  business_unit = ${filterCriteria.businessUnit} AND
                  trandate = ${filterCriteria.trandate}`;

    Account[]|error response = runQueryAccount(query);
    return response;
}

function getExpenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns Account[]|error {

    sql:ParameterizedQuery query = `SELECT id AS Id, 
            account AS AccountName, 
            amount as Amount, 
            mis_updated_value AS BudgetedValue, 
            comment AS Comment
            FROM mis_expense
            WHERE account_type = 'Cost of Goods Sold' AND
                  account_category = ${filterCriteria.accountCategory} AND
                  mis_flash_section = ${filterCriteria.categoryType} AND
                  business_unit = ${filterCriteria.businessUnit} AND
                  trandate = ${filterCriteria.trandate}`;

    Account[]|error response = runQueryAccount(query);
    return response;
}

function runQueryAccount(sql:ParameterizedQuery query) returns Account[]|error {
    Account[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(AccountData)
        select new Account(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}
