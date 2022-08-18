// --------- filter criterias ---------

type IncomeAccountFilterCriteria record {
    int? id = ();
    string? accountCategory = ();
    string? businessUnit = ();
    string? month = ();
    DatePeriodFilterCriteria? range = ();
};

type ExpenseAccountFilterCriteria record {
    int? id = ();
    string? accountCategory = ();
    string? businessUnit = ();
    string? expenseType = ();
    string? month = ();
    DatePeriodFilterCriteria? range = ();
};

type ExpenseAccountGroupFilterCriteria record {
    DatePeriodFilterCriteria range;
    ExpenseGroupByFilter groupBy;
};

type ExpenseGroupByFilter record {
    boolean? accountType;
    boolean? accountCategory;
    boolean? expenseType;
    boolean? businessUnit;
};

type IncomeAccountGroupFilterCriteria record {
    DatePeriodFilterCriteria range;
    IncomeGroupByFilter groupBy;
};

type IncomeGroupByFilter record {
    boolean? accountType;
    boolean? accountCategory;
    boolean? incomeType;
    boolean? businessUnit;
};

type DatePeriodFilterCriteria record {|
    string startDate;
    string endDate;
|};

public type IncomeExpAcValUpdParameterRecord record {
    int id;
    decimal value;
    string? comment;
};

public type IncExpTrandateByIDRequestRecord record {
    int id;
    string prevYearMonth;
};

public type IncExpTrandateByIDRespRecord record {
    int isPrevMonth;
};

// --------- data records ---------

type IncomeAccountData record {
    int id;
    string accountName;
    string? comment;
    decimal? budgetedValue;
    string month;
    decimal amount;
};

type ExpenseAccountData record {
    int id;
    string accountName;
    string? comment;
    decimal? budgetedValue;
    string month;
    decimal amount;
};

type SumOfIncomeAccountData record {
    string? accountType = ();
    string? accountCategory = ();
    string? businessUnit = ();
    string? incomeType = ();
    decimal balance;
};

type SumOfExpenseAccountData record {
    string? accountType = ();
    string? accountCategory = ();
    string? businessUnit = ();
    string? expenseType = ();
    decimal balance;
};

type UpdatedRecord record {
    string? id;
};