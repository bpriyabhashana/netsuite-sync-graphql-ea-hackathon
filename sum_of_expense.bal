import ballerina/sql;

service class SumOfExpense {
    private final readonly & SumOfExpenseData data;

    function init(SumOfExpenseData data) {
        self.data = data.cloneReadOnly();
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

function getExpenseTypeBalance(DatePeriodFilterCriteria filterCriteria) returns SumOfExpense[]|error {

    sql:ParameterizedQuery query = `SELECT 
                   account_category AS AccountCategory, 
                   mis_flash_section AS ExpenseType, 
                   business_unit AS BusinessUnit, 
                   SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
                   AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS Balance  
            FROM mis_expense 
            WHERE trandate > SUBSTRING(${filterCriteria.startDate}, 1, 7) AND 
                  trandate <= SUBSTRING(${filterCriteria.endDate}, 1, 7)
            GROUP BY account_type, account_category, mis_flash_section, business_unit`;

    SumOfExpense[]|error response = runQuerySumOfExpense(query);

    return response;
}


function runQuerySumOfExpense(sql:ParameterizedQuery query) returns SumOfExpense[]|error {
    SumOfExpense[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(SumOfExpenseData)
        select new SumOfExpense(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}
