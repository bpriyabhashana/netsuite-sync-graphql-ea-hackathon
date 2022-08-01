import ballerina/sql;

service class SummaryRecord {
    private final readonly & SummaryRecordData data;

    function init(SummaryRecordData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get account_type() returns string? {
        return self.data.account_type;
    }

    resource function get account_category() returns string? {
        return self.data.account_category;
    }

    resource function get business_unit() returns string? {
        return self.data.business_unit;
    }

    resource function get amount() returns decimal? {
        return self.data.amount;
    }

}

function loadDynamicIncomeSummaryData(DatePeriodFilterCriteria filterCriteria) returns SummaryRecord[]|error {

    sql:ParameterizedQuery query = `SELECT account_type, 
                   account_category, 
                   mis_flash_section, 
                   business_unit, 
                   SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
                   AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS amount  
            FROM mis_income 
            WHERE trandate > SUBSTRING(${filterCriteria.startDate}, 1, 7) AND 
                  trandate <= SUBSTRING(${filterCriteria.endDate}, 1, 7)
            GROUP BY account_type, account_category, mis_flash_section, business_unit`;

    SummaryRecord[]|error response = runQuerySummaryRecord(query);

    return response;
}

function loadDynamicExpenseSummaryData(DatePeriodFilterCriteria filterCriteria) returns SummaryRecord[]|error {

    sql:ParameterizedQuery query = `SELECT account_type, 
                   account_category, 
                   mis_flash_section, 
                   business_unit, 
                   SUM((CASE WHEN (DATE_FORMAT(UTC_TIMESTAMP() - INTERVAL 1 MONTH, '%Y-%m') = trandate) 
                   AND (DAY(UTC_TIMESTAMP()) <= ${dateCutoff}) THEN COALESCE(mis_updated_value, amount) ELSE amount END)) AS amount  
            FROM mis_expense 
            WHERE trandate > SUBSTRING(${filterCriteria.startDate}, 1, 7) AND 
                  trandate <= SUBSTRING(${filterCriteria.endDate}, 1, 7)
            GROUP BY account_type, account_category, mis_flash_section, business_unit`;

    SummaryRecord[]|error response = runQuerySummaryRecord(query);

    return response;
}

function runQuerySummaryRecord(sql:ParameterizedQuery query) returns SummaryRecord[]|error {
    SummaryRecord[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);

    payload = check from var item in resultStream
        let var accRow = check item.cloneWithType(SummaryRecordData)
        select new SummaryRecord(accRow);

    if (payload is null) {
        return [];
    }
    return payload;
}
