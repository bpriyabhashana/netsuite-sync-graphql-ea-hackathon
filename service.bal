import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {

    resource function get incomeAccount(IncomeAccountFilterCriteria filterCriteria) returns IncomeAccount[]|error? {

        return getIncomeAccount(filterCriteria);
    }

    resource function get expenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns ExpenseAccount[]|error? {

        return getExpenseAccount(filterCriteria);
    }

    resource function get sumOfIncomeAccounts(DatePeriodFilterCriteria filterCriteria) returns SumOfIncomeAccount[]|error? {

        return getSumOfIncomeAccounts(filterCriteria);
    }

    resource function get sumOfExpenseAccounts(DatePeriodFilterCriteria filterCriteria) returns SumOfExpenseAccount[]|error? {

        return getSumOfExpenseAccounts(filterCriteria);
    }

}
