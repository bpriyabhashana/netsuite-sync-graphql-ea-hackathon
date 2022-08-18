const dateCutoff = 25;

# Income and Expense type
const INCOME = "income";
const EXPENSE = "expense";

string errorCutoffDatePassed = "Editing is blocked. This may be due to the Cutoff date: " + dateCutoff.toString() + " is already passed, " +
                                        "OR the GL account value you are editing does not belong to the past month. " +
                                        "hence editing the given Income/Expense GL Account value is not permitted";
