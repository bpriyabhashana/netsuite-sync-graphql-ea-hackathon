import ballerina/sql;

isolated function getExpenseRecordTrandateByIDQuery(IncExpTrandateByIDRequestRecord incExpTrandateByIDRequestRecord) returns sql:ParameterizedQuery {
    return `SELECT trandate = ${incExpTrandateByIDRequestRecord.prevYearMonth} AS isPrevMonth
            FROM mis_expense
            WHERE id = ${incExpTrandateByIDRequestRecord.id}`;
}

isolated function getIncomeRecordTrandateByIDQuery(IncExpTrandateByIDRequestRecord incExpTrandateByIDRequestRecord) returns sql:ParameterizedQuery {
    return `SELECT trandate = ${incExpTrandateByIDRequestRecord.prevYearMonth} AS isPrevMonth
            FROM mis_income
            WHERE id = ${incExpTrandateByIDRequestRecord.id}`;
}

isolated function updateNSIncomeAcValEachBULastMonthQuery(IncomeExpAcValUpdParameterRecord incomeExpAcValUpdParameterRecord)
                                                returns sql:ParameterizedQuery {
    return `UPDATE mis_income
            SET mis_updated_value = ${incomeExpAcValUpdParameterRecord.value}, 
                comment = ${incomeExpAcValUpdParameterRecord.comment}
            WHERE id = ${incomeExpAcValUpdParameterRecord.id}`;
}

function updateNSExpenseAcValEachBULastMonthQuery(IncomeExpAcValUpdParameterRecord incomeExpAcValUpdParameterRecord)
                                                returns sql:ParameterizedQuery {
    return `UPDATE mis_expense
            SET mis_updated_value = ${incomeExpAcValUpdParameterRecord.value},
                comment = ${incomeExpAcValUpdParameterRecord.comment}
            WHERE id = ${incomeExpAcValUpdParameterRecord.id}`;
}