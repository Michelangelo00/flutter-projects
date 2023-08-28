import 'package:flutter/material.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/widget/income_expense_card.dart';

class HomeScreenTab extends StatelessWidget {
  const HomeScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(defaultSpacing),
        child: Column(
          children: [
            SizedBox(
              height: defaultSpacing * 4,
            ),
            Row(
              children: [
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData:
                      ExpenseData("Income", "2000", Icons.arrow_upward_rounded),
                )),
                SizedBox(
                  width: defaultSpacing,
                ),
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                      "Expense", "9,000.00", Icons.arrow_downward_rounded),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
