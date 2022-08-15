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
    GroupByFilterCriteria groupBy;
};

type GroupByFilterCriteria record {
    boolean? AccountType;
    boolean? AccountCategory;
    boolean? ExpenseType;
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
    string AccountType;
    string AccountCategory;
    string BusinessUnit;
    decimal Balance;
};

type SumOfExpenseAccountData record {
    string? AccountType = ();
    string? AccountCategory = ();
    string? BusinessUnit = ();
    string? ExpenseType = ();
    decimal Balance;
};



// ----------- outdated -----------

// expense type data
type SumOfExpenseData record {
    string AccountCategory;
    string ExpenseType;
    string BusinessUnit;
    decimal Balance;
};

// add income and expense 
// add category as enum