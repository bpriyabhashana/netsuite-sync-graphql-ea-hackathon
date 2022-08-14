import ballerina/sql;

service class SumOfIncomeAccount {
    private final readonly & SumOfIncomeAccountData data;

    function init(SumOfIncomeAccountData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get AccountType() returns string? {
        return self.data.AccountType;
    }

    resource function get AccountCategory() returns string? {
        return self.data.AccountCategory;
    }

    resource function get BusinessUnit() returns string? {
        return self.data.BusinessUnit;
    }

    resource function get Balance() returns decimal? {
        return self.data.Balance;
    }

}

# Load income summary data based on startDate, endDate
# e.g. startDate: "2021-02", endDate: "2021-09"
# the result will be group by account_type, account_category, business_unit
# if the query execution succeeded, it returns the SummaryRecord
#
# + filterCriteria - (refer records.bal for more details)  
# + return - SummaryRecord[]|error  

function getSumOfIncomeAccounts(DatePeriodFilterCriteria filterCriteria) returns SumOfIncomeAccount[]|error {

    sql:ParameterizedQuery query = `SELECT account_type AS AccountType, 
                   account_category AS AccountCategory, 
                   business_unit AS BusinessUnit, 
                   SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
                   AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS Balance
                    FROM mis_income
                    WHERE trandate > SUBSTRING(${filterCriteria.startDate}, 1, 7) AND 
                    trandate <= SUBSTRING(${filterCriteria.endDate}, 1, 7)
                    GROUP BY account_type, account_category, business_unit`;

    SumOfIncomeAccount[]|error response = runQuerySumOfIncomeAccounts(query);

    return response;
}

function runQuerySumOfIncomeAccounts(sql:ParameterizedQuery query) returns SumOfIncomeAccount[]|error {
    SumOfIncomeAccount[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(SumOfIncomeAccountData)
        select new SumOfIncomeAccount(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}
