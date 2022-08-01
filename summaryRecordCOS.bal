import ballerina/sql;

service class SummaryRecordCOS {
    private final readonly & SummaryRecordCOSData data;

    function init(SummaryRecordCOSData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get AccountType() returns string? {
        return self.data.account_type;
    }

    resource function get AccountCategory() returns string? {
        return self.data.account_category;
    }

    resource function get CostType() returns string? {
        return self.data.cost_type;
    }

    resource function get BusinessUnit() returns string? {
        return self.data.business_unit;
    }

    resource function get Amount() returns decimal? {
        return self.data.amount;
    }

}

function loadDynamicExpenseCOSSummaryData(DatePeriodFilterCriteria filterCriteria) returns SummaryRecordCOS[]|error {

    sql:ParameterizedQuery query = `SELECT account_type, 
                   account_category, 
                   mis_flash_section as cost_type, 
                   business_unit, 
                   SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS amount  
            FROM mis_expense 
            WHERE trandate > SUBSTRING(${filterCriteria.startDate}, 1, 7) AND 
                  trandate <= SUBSTRING(${filterCriteria.endDate}, 1, 7)
            GROUP BY account_type, account_category, mis_flash_section, business_unit`;

    SummaryRecordCOS[]|error response = runQuerySummaryRecordCOS(query);

    return response;
}

function runQuerySummaryRecordCOS(sql:ParameterizedQuery query) returns SummaryRecordCOS[]|error {
    SummaryRecordCOS[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(SummaryRecordCOSData)
        select new SummaryRecordCOS(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}
