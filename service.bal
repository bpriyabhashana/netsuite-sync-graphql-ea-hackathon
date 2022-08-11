import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {

    resource function get incomeAccount(IncomeAccountFilterCriteria filterCriteria) returns Account[]|error? {

        return getIncomeAccount(filterCriteria);
    }

    resource function get expenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns Account[]|error? {

        return getExpenseAccount(filterCriteria);
    }

    resource function get accountBalance(BalanceFilterCriteria filterCriteria) returns SumOfAccount[]|error? {

        return getAccountBalance(filterCriteria);
    }

    resource function get expenseTypeBalance(DatePeriodFilterCriteria filterCriteria) returns SumOfExpense[]|error? {

        return getExpenseTypeBalance(filterCriteria);
    }

}
