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
    string account_type;
    string account_category;
    string business_unit;
    decimal amount;
};

type SummaryRecordCOSData record {
    string account_type;
    string account_category;
    string cost_type;
    string business_unit;
    decimal amount;
};

type AccountRecordData record {
    int id;
    int internalid;
    string account;
    string? comment;
    decimal? mis_updated_value;
    decimal amount;
};

type AvailabilityData record {
    int IsAvailable;
};