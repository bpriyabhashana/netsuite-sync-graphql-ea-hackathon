import ballerina/sql;

service class AccountRecord {
     private final readonly & AccountRecordData data;

      function init(AccountRecordData data) {
        self.data = data.cloneReadOnly();
    }

    resource function get Id() returns int? {
        return self.data.id;
    }
    
     resource function get InternalId() returns int? {
        return self.data.internalid;
    }

    resource function get Account() returns string? {
        return self.data.account;
    }

    resource function get Comment() returns string? {
        return self.data.comment;
    }

    resource function get MisUpdatedValue() returns decimal? {
        return self.data.mis_updated_value;
    }

    resource function get Amount() returns decimal? {
        return self.data.amount;
    }

}


function loadDynamicIncomeAccountData(IncomeAccountFilterCriteria filterCriteria) returns AccountRecord[]|error {

 sql:ParameterizedQuery query = `SELECT id, internalid, account, amount, mis_updated_value, comment
            FROM mis_income
            WHERE account_type = 'Income' AND
                  account_category = ${filterCriteria.accountCategory} AND
                  business_unit = ${filterCriteria.businessUnit} AND
                  trandate = ${filterCriteria.trandate}`;

            AccountRecord[]|error response = runQueryAccountRecord(query);
    return response;
}

function loadDynamicExpenseAccountData(ExpenseAccountFilterCriteria filterCriteria) returns AccountRecord[]|error {

 sql:ParameterizedQuery query = `SELECT id, internalid, account, amount, mis_updated_value, comment
            FROM mis_expense
            WHERE account_type = 'Cost of Goods Sold' AND
                  account_category = ${filterCriteria.accountCategory} AND
                  mis_flash_section = ${filterCriteria.misFlashSection} AND
                  business_unit = ${filterCriteria.businessUnit} AND
                  trandate = ${filterCriteria.trandate}`;

            AccountRecord[]|error response = runQueryAccountRecord(query);
    return response;
}

function runQueryAccountRecord(sql:ParameterizedQuery query) returns AccountRecord[]|error {
    AccountRecord[]? payload = [];

    stream<record {}, error?> resultStream = mysqlClient->query(query);


    payload = check from var item in resultStream 
            let var accRow = check item.cloneWithType(AccountRecordData) 
            select new AccountRecord(accRow);

    if(payload is null) {
        return [];
    }
    return payload;
}