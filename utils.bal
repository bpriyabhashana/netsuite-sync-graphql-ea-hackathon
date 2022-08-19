import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;
import ballerina/time;
import ballerina/lang.'int as ints;

configurable string dbHost = ?;
configurable string dbUser = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbPort = ?;

final mysql:Client mysqlClient = check new (host = dbHost,
                                    user = dbUser,
                                    password = dbPassword,
                                    database = dbName,
                                    port = dbPort);


function isCutoffDateNotPassed() returns boolean|error {
    // Get the current epoch time
    time:Utc utc = time:utcNow();
    // Converts a given `time:Utc` time to a RFC 3339 timestamp
    // e.g. 2022-02-19T10:15:30.00Z
    string x = time:utcToString(utc);
    // Extract the date portion from RFC 3339 timestamp
    int i = check ints:fromString(x[8] + x[9]);
    // Check whether the current date is less than or equal to the cutoff date
    return i <= dateCutoff;
}

function isPreviousMonth(IncomeExpAcValUpdParameterRecord incomeExpAcValUpdParameterRecord,
                        string typeIncomeExpense) returns boolean|error {

    IncExpTrandateByIDRequestRecord incExpTrandateByIDRequestRecord = {
        id: incomeExpAcValUpdParameterRecord.id,
        prevYearMonth: check getPreviousYearMonth()
    };

    if typeIncomeExpense == EXPENSE {
        json expenseTrandate = check getExpenseRecordTrandateByID(incExpTrandateByIDRequestRecord);
        IncExpTrandateByIDRespRecord incExpTrandateByIDRespRecord = check expenseTrandate.cloneWithType(IncExpTrandateByIDRespRecord);
        return incExpTrandateByIDRespRecord.isPrevMonth == 1 ? true : false;
    } else if typeIncomeExpense == INCOME {
        json incomeTrandate = check getIncomeRecordTrandateByID(incExpTrandateByIDRequestRecord);
        IncExpTrandateByIDRespRecord incExpTrandateByIDRespRecord = check incomeTrandate.cloneWithType(IncExpTrandateByIDRespRecord);
        return incExpTrandateByIDRespRecord.isPrevMonth == 1 ? true : false;
    }
    return false;
}

function getPreviousYearMonth() returns string|error {
    string nowStr = time:utcToString(time:utcNow());
    int currentMonth = 0;
    int currentYear = 0;
    int prevMonth = 0;
    int prevYear = 0;
    do {
        currentYear = check ints:fromString(nowStr[0] + nowStr[1] + nowStr[2] + nowStr[3]);
        currentMonth = check ints:fromString(nowStr[5] + nowStr[6]);
        if currentMonth - 1 == 0 {
            prevMonth = 12;
            prevYear = currentYear - 1;
        } else {
            prevMonth = currentMonth - 1;
            prevYear = currentYear;
        }
        return prevYear.toString() + "-" + (prevMonth.toString().length() == 1 ? "0" + prevMonth.toString() : prevMonth.toString());
    } on fail error err {
        return err;
    }
}

public isolated function fromSQLExecResultToJSON(sql:ExecutionResult result) returns json {
    return {
        "affectedRowCount": result.affectedRowCount,
        "lastInsertId": result.lastInsertId
    };
}
