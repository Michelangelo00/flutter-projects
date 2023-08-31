import 'package:flutter/material.dart';
import 'package:moneymanagerapp/data/userInfo.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/widget/income_expense_card.dart';
import 'package:moneymanagerapp/widget/transiction_item_title.dart';

class HomeScreenTab extends StatefulWidget {
  final List<Transaction> transactions;
  UserInfo userdata;

  HomeScreenTab(
      {super.key, required this.transactions, required this.userdata});

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
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
              title: Text("Hey! ${widget.userdata.name}!"),
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
                  widget.userdata.totalBalance,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData("Income", widget.userdata.inflow,
                      Icons.arrow_upward_rounded),
                )),
                const SizedBox(
                  width: defaultSpacing,
                ),
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                      "Expense",
                      "-${widget.userdata.outflow}",
                      Icons.arrow_downward_rounded),
                ))
              ],
            ),
            const SizedBox(
              height: defaultSpacing * 2,
            ),
            Text(
              "Transazioni",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: defaultSpacing,
            ),
            ...widget.transactions.map((transaction) => TransictionItemTitle(
                  transaction: transaction,
                )),
          ],
        ),
      ),
    );
  }
}
