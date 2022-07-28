import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {

     resource function get incomeSummary(DatePeriodFilterCriteria filterCriteria) returns SummaryRecord[]|error? {

        return loadDynamicIncomeSummaryData(filterCriteria);
    }

    resource function get expenseSummary(DatePeriodFilterCriteria filterCriteria) returns SummaryRecord[]|error? {

        return loadDynamicExpenseSummaryData(filterCriteria);
    }

    resource function get incomeAccount(IncomeAccountFilterCriteria filterCriteria) returns AccountRecord[]|error? {

        return loadDynamicIncomeAccountData(filterCriteria);
    }

    resource function get expenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns AccountRecord[]|error? {

        return loadDynamicExpenseAccountData(filterCriteria);
    }

    

}
