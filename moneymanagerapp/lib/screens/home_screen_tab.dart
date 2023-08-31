import 'package:flutter/material.dart';
import 'package:moneymanagerapp/data/userInfo.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/utils/database_helper.dart';
import 'package:moneymanagerapp/widget/income_expense_card.dart';
import 'package:moneymanagerapp/widget/transiction_item_title.dart';

class HomeScreenTab extends StatefulWidget {
  final List<Transaction> transactions;
  final UserInfo userdata;
  final VoidCallback onReload;

  const HomeScreenTab(
      {Key? key,
      required this.transactions,
      required this.userdata,
      required this.onReload})
      : super(key: key);

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  List<Transaction> _transactions = []; // 1. Aggiorna lo stato

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  _loadTransactions() async {
    List<Transaction> loadedTransactions =
        await DatabaseHelper.instance.getTransactions();
    setState(() {
      _transactions = loadedTransactions;
    });
  }

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
                  "${widget.userdata.totalBalance}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 25, fontWeight: FontWeight.w800),
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
                  expenseData: ExpenseData("Entrate", widget.userdata.entrata,
                      Icons.arrow_upward_rounded),
                )),
                const SizedBox(
                  width: defaultSpacing,
                ),
                Expanded(
                    child: IncomeExpenseCard(
                  expenseData: ExpenseData(
                      "Uscite",
                      "-${widget.userdata.uscita}",
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
            FutureBuilder<List<Transaction>>(
              future: DatabaseHelper.instance.getTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Si è verificato un errore: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nessuna transazione disponibile.'),
                  );
                } else {
                  List<Transaction> transactions = snapshot.data!;
                  transactions = List.from(transactions.reversed);
                  return Column(
                    children: transactions.map((transaction) {
                      return TransictionItemTitle(
                        transaction: transaction,
                        onReload: _loadTransactions,
                        onTransactionDeleted: _onTransactionDeleted,
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onTransactionDeleted(double amount, TransactionType type) {
    setState(() {
      if (type == TransactionType.entrata) {
        String entrataWithoutCurrency =
            widget.userdata.entrata.replaceAll('€', '').trim();
        widget.userdata.entrata =
            '${double.parse(entrataWithoutCurrency) - amount}€';
      } else if (type == TransactionType.uscita) {
        String uscitaWithoutCurrency =
            widget.userdata.uscita.replaceAll('€', '').trim();
        widget.userdata.uscita =
            '${double.parse(uscitaWithoutCurrency) - amount}€';
      }

      String entrataWithoutCurrency =
          widget.userdata.entrata.replaceAll('€', '').trim();
      String uscitaWithoutCurrency =
          widget.userdata.uscita.replaceAll('€', '').trim();
      widget.userdata.totalBalance =
          '${double.parse(entrataWithoutCurrency) - double.parse(uscitaWithoutCurrency)}€';
    });
  }
}
