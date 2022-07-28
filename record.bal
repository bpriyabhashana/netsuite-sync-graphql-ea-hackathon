
type DatePeriodFilterCriteria record {
    string startDate;
    string endDate;
};

type IncomeAccountFilterCriteria record {
    string account_category;
    string business_unit;
    string trandate;
};

type ExpenseAccountFilterCriteria record {
    string account_category;
    string business_unit;
    string mis_flash_section;
    string trandate;
};

type SummaryRecordData record {
    string account_type;
    string account_category;
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