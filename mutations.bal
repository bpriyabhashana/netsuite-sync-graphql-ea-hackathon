import ballerina/sql;

function updateIncomeAccount(IncomeExpAcValUpdParameterRecord payload) returns IncomeAccount[]|error {

    do {
        if check isCutoffDateNotPassed()
            // && check isPreviousMonth(payload, INCOME)
            {
            json _ = check updateNSIncomeAccountValue(payload);

            return getIncomeAccount({id: payload.id});
        }
            else {
            return error(errorCutoffDatePassed);
        }
    } on fail error err {
        return err;
    }
}

function updateExpenseAccount(IncomeExpAcValUpdParameterRecord payload) returns ExpenseAccount[]|error {

    do {
        if check isCutoffDateNotPassed()
            // && check isPreviousMonth(payload, EXPENSE)
            {
            json _ = check updateNSExpenseAccountValue(payload);

            return getExpenseAccount({id: payload.id});
        }
            else {
            return error(errorCutoffDatePassed);
        }
    } on fail error err {
        return err;
    }
}

function updateNSIncomeAccountValue(IncomeExpAcValUpdParameterRecord incomeExpAcValUpdParameterRecord) returns json|error {
    sql:ExecutionResult result = check updateNSIncomeAcValEachBULastMonth(incomeExpAcValUpdParameterRecord);
    return fromSQLExecResultToJSON(result);
}

function updateNSExpenseAccountValue(IncomeExpAcValUpdParameterRecord incomeExpAcValUpdParameterRecord) returns json|error {
    sql:ExecutionResult result = check updateNSExpenseAcValEachBULastMonth(incomeExpAcValUpdParameterRecord);
    return fromSQLExecResultToJSON(result);
}
