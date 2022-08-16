// --------- filter criterias ---------

type IncomeAccountFilterCriteria record {
    string? accountCategory = ();
    string? businessUnit = ();
    string? month = ();
    DatePeriodFilterCriteria? range = ();
};

type ExpenseAccountFilterCriteria record {
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
    boolean? AccountType;
    boolean? AccountCategory;
    boolean? ExpenseType;
    boolean? BusinessUnit;
};

type IncomeAccountGroupFilterCriteria record {
    DatePeriodFilterCriteria range;
    IncomeGroupByFilter groupBy;
};

type IncomeGroupByFilter record {
    boolean? AccountType;
    boolean? AccountCategory;
    boolean? IncomeType;
    boolean? BusinessUnit;
};

type DatePeriodFilterCriteria record {|
    string startDate;
    string endDate;
|};

// --------- data records ---------

type IncomeAccountData record {
    int Id;
    string AccountName;
    string? Comment;
    decimal? BudgetedValue;
    string Month;
    decimal Amount;
};

type ExpenseAccountData record {
    int Id;
    string AccountName;
    string? Comment;
    decimal? BudgetedValue;
    string Month;
    decimal Amount;
};

type SumOfIncomeAccountData record {
    string? AccountType = ();
    string? AccountCategory = ();
    string? BusinessUnit = ();
    string? IncomeType = ();
    decimal Balance;
};

type SumOfExpenseAccountData record {
    string? AccountType = ();
    string? AccountCategory = ();
    string? BusinessUnit = ();
    string? ExpenseType = ();
    decimal Balance;
};