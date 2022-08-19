import ballerina/sql;

public function getExpenseRecordTrandateByID(IncExpTrandateByIDRequestRecord incExpTrandateByIDRequestRecord) returns json|error {

    json expenseTrandate = {};

    stream<record {}, error?> resultStream = mysqlClient->query(getExpenseRecordTrandateByIDQuery(incExpTrandateByIDRequestRecord));

    error? e = resultStream.forEach(function(record {} result) {
        expenseTrandate = result.toJson();
    });

    if (e is error) {
        return e;
    }

    return expenseTrandate;
}

public function getIncomeRecordTrandateByID(IncExpTrandateByIDRequestRecord incExpTrandateByIDRequestRecord) returns json|error {

    json incomeTrandate = {};

    stream<record {}, error?> resultStream = mysqlClient->query(getIncomeRecordTrandateByIDQuery(incExpTrandateByIDRequestRecord));

    error? e = resultStream.forEach(function(record {} result) {
        incomeTrandate = result.toJson();
    });

    if (e is error) {
        return e;
    }

    return incomeTrandate;
}

public function updateNSIncomeAcValEachBULastMonth(IncomeExpAcValUpdParameterRecord incomeExpAcValUpdParameterRecord)
                                                    returns sql:ExecutionResult|sql:Error {

    return mysqlClient->execute(updateNSIncomeAcValEachBULastMonthQuery(incomeExpAcValUpdParameterRecord));
}

public function updateNSExpenseAcValEachBULastMonth(IncomeExpAcValUpdParameterRecord incomeExpAcValUpdParameterRecord)
                                                    returns sql:ExecutionResult|sql:Error {

    return mysqlClient->execute(updateNSExpenseAcValEachBULastMonthQuery(incomeExpAcValUpdParameterRecord));
}
