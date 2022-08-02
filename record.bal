// --------- filter criterias ---------

type DatePeriodFilterCriteria record {
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
    string misFlashSection;
    string trandate;
};

type DateIdFilterCriteria record {
    int id;
    string yearMonth;
};

// --------- data records ---------

type SummaryRecordData record {
    string AccountType;
    string AccountCategory;
    string BusinessUnit;
    decimal Amount;
};

type SummaryRecordCOSData record {
    string AccountType;
    string AccountCategory;
    string Type;
    string BusinessUnit;
    decimal Amount;
};

type AccountRecordData record {
    int Id;
    int InternalId;
    string Account;
    string? Comment;
    decimal? UpdatedValue;
    decimal Amount;
};

type AvailabilityData record {
    int IsAvailable;
};