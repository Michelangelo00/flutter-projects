import 'package:flutter/material.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/widget/income_expense_card.dart';

class HomeScreenTab extends StatelessWidget {
  const HomeScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(defaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultSpacing * 4,
            ),
            ListTile(
              title: const Text("Hey! Michelangelo!"),
              leading: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(defaultRadius * 4)),
                child: Image.asset("assets/image/profile.jpeg"),
              ),
              trailing: const Icon(Icons.notifications),
            ),
            const SizedBox(
              height: defaultSpacing,
            ),
            Center(
              child: Column(children: [
                Text(
                  "€4,586.00",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: fontSizeHeading, fontWeight: FontWeight.w800),
                ),
                Text("Total balance",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: fontSubHeading))
              ]),
            ),
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                      "Income", "€2,400", Icons.arrow_upward_rounded),
                )),
                SizedBox(
                  width: defaultSpacing,
                ),
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                      "Expense", "-€710.00", Icons.arrow_downward_rounded),
                ))
              ],
            ),
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            Text(
              "Recent Transictions",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: defaultSpacing,
            ),
            const Text(
              "Today",
              style: TextStyle(color: fontSubHeading),
            )
          ],
        ),
      ),
    );
  }
}
