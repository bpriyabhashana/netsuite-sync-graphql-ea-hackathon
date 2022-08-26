import ballerina/graphql;

service /graphql on new graphql:Listener(9090) {

# Get income account list for a given filter criteria 
    #  
    # + filterCriteria - IncomeAccountFilterCriteria  
    # + return - IncomeAccount|error  
    resource function get incomeAccount(IncomeAccountFilterCriteria filterCriteria) returns IncomeAccount[]|error? {
        return getIncomeAccount(filterCriteria);
    }

# Get expense account list for a given filter criteria 
    #  
    # + filterCriteria - ExpenseAccountFilterCriteria  
    # + return - ExpenseAccount|error  
    resource function get expenseAccount(ExpenseAccountFilterCriteria filterCriteria) returns ExpenseAccount[]|error? {
        return getExpenseAccount(filterCriteria);
    }

# Get sum of income accounts for a given filter criteria 
    #  
    # + filterCriteria - IncomeAccountGroupFilterCriteria  
    # + return - SumOfIncomeAccount|error  
    resource function get sumOfIncomeAccounts(IncomeAccountGroupFilterCriteria filterCriteria) returns SumOfIncomeAccount[]|error? {
        return getSumOfIncomeAccounts(filterCriteria);
    }

# Get sum of expense accounts for a given filter criteria 
    #  
    # + filterCriteria - ExpenseAccountGroupFilterCriteria  
    # + return - SumOfExpenseAccount|error  
    resource function get sumOfExpenseAccounts(ExpenseAccountGroupFilterCriteria filterCriteria) returns SumOfExpenseAccount[]|error? {
        return getSumOfExpenseAccounts(filterCriteria);
    }

# Update income account for a given parameters 
    #  
    # + payload - ExpenseAccountGroupFilterCriteria  
    # + return - IncomeAccount|error  
    remote function updateIncomeAccount(IncomeExpAcValUpdParameterRecord payload) returns IncomeAccount[]|error {
        return check updateIncomeAccount(payload);
    }

# Update expense account for a given parameters 
    #  
    # + payload - ExpenseAccountGroupFilterCriteria  
    # + return - IncomeAccount|error  
    remote function updateExpenseAccount(IncomeExpAcValUpdParameterRecord payload) returns ExpenseAccount[]|error {
        return check updateExpenseAccount(payload);
    }

}
