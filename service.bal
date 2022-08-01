import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {

     resource function get income(DatePeriodFilterCriteria filterCriteria) returns SummaryRecord[]|error? {

        return loadDynamicIncomeSummaryData(filterCriteria);
    }

    resource function get expense(DatePeriodFilterCriteria filterCriteria) returns SummaryRecord[]|error? {

        return loadDynamicExpenseSummaryData(filterCriteria);
    }

    resource function get expenseCOS(DatePeriodFilterCriteria filterCriteria) returns SummaryRecordCOS[]|error? {

        return loadDynamicExpenseCOSSummaryData(filterCriteria);
    }

    resource function get incomeAccount(IncomeAccountFilterCriteria filterCriteria) returns AccountRecord[]|error? {

        return loadDynamicIncomeAccountData(filterCriteria);
    }

    resource function get expenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns AccountRecord[]|error? {

        return loadDynamicExpenseAccountData(filterCriteria);
    }

    
}
