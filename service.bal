import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {

     resource function get incomeSummary(DatePeriodFilterCriteria datePeriodFilterCriteria) returns SummaryRecord[]|error? {

        return loadDynamicIncomeSummaryData(datePeriodFilterCriteria);
    }

    resource function get expenseSummary(DatePeriodFilterCriteria datePeriodFilterCriteria) returns SummaryRecord[]|error? {

        return loadDynamicExpenseSummaryData(datePeriodFilterCriteria);
    }

    resource function get incomeAccount(IncomeAccountFilterCriteria incomeAccountFilterCriteria) returns AccountRecord[]|error? {

        return loadDynamicIncomeAccountData(incomeAccountFilterCriteria);
    }

    resource function get expenseAccount(ExpenseAccountFilterCriteria expenseAccountFilterCriteria) returns AccountRecord[]|error? {

        return loadDynamicExpenseAccountData(expenseAccountFilterCriteria);
    }

    

}
