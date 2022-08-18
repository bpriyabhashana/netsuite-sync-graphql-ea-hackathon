import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {

    resource function get incomeAccount(IncomeAccountFilterCriteria filterCriteria) returns IncomeAccount[]|error? {

        return getIncomeAccount(filterCriteria);
    }

    resource function get expenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns ExpenseAccount[]|error? {

        return getExpenseAccount(filterCriteria);
    }

    resource function get sumOfIncomeAccounts(IncomeAccountGroupFilterCriteria filterCriteria) returns SumOfIncomeAccount[]|error? {

        return getSumOfIncomeAccounts(filterCriteria);
    }

    resource function get sumOfExpenseAccounts(ExpenseAccountGroupFilterCriteria filterCriteria) returns SumOfExpenseAccount[]|error? {

        return getSumOfExpenseAccounts(filterCriteria);
    }

    remote function updateIncomeAccount(IncomeExpAcValUpdParameterRecord payload) returns IncomeAccount[]|error {
        
        return check updateIncomeAccount(payload);
        
    }

    remote function updateExpenseAccount(IncomeExpAcValUpdParameterRecord payload) returns ExpenseAccount[]|error {
        
        return check updateExpenseAccount(payload);
        
    }

}
