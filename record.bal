// --------- filter criterias ---------

type BalanceFilterCriteria record {
    string balanceType;
    string startDate;
    string endDate;
};

type IncomeAccountFilterCriteria record {
    string accountCategory;
    string businessUnit;
    string trandate;
};

type ExpenseAccountFilterCriteria record {
    string accountCategory;
    string businessUnit;
    string categoryType;
    string trandate;
};

type DatePeriodFilterCriteria record {
    string startDate;
    string endDate;
};

type DateIdFilterCriteria record {
    int id;
    string yearMonth;
};

// --------- data records ---------

type AccountData record {
    int Id;
    string AccountName;
    string? Comment;
    decimal? BudgetedValue;
    decimal Amount;
};

type SumOfAccountData record {
    string AccountType;
    string AccountCategory;
    string BusinessUnit;
    decimal Balance;
};

type SumOfExpenseData record {
    string AccountCategory;
    string ExpenseType;
    string BusinessUnit;
    decimal Balance;
};

// add income and expense 
// add category as enum