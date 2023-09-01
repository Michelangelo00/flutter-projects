import 'package:flutter/material.dart';
import 'package:moneymanagerapp/data/userInfo.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/utils/database_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:moneymanagerapp/widget/transiction_item_title.dart';

class HomeStatTab extends StatefulWidget {
  final List<Transaction> transactions;
  final UserInfo userdata;
  final Function() onReload;

  const HomeStatTab(
      {super.key,
      required this.userdata,
      required this.onReload,
      required this.transactions});

  @override
  _HomeStatTabState createState() => _HomeStatTabState();
}

class _HomeStatTabState extends State<HomeStatTab> {
  String? selectedMonth;
  String? selectedYear;
  List<Transaction> _transactions = []; // 1. Aggiorna lo stato

  List<String> months = [
    "Gennaio",
    "Febbraio",
    "Marzo",
    "Aprile",
    "Maggio",
    "Giugno",
    "Luglio",
    "Agosto",
    "Settembre",
    "Ottobre",
    "Novembre",
    "Dicembre"
  ];

  List<String> years = List<String>.generate(1101, (int index) {
    return (1900 + index).toString();
  });

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    selectedYear = now.year.toString();
    selectedMonth = months[now.month - 1];

    // Carica i dati all'inizializzazione
    loadData();
  }

  loadData() async {
    List<Transaction> loadedTransactions = await DatabaseHelper.instance
        .getTransactionsForMonthAndYear(selectedMonth!, selectedYear!, months);
    setState(() {
      _transactions = loadedTransactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Numero di giorni nel mese
    int daysInMonth = DateTime(
      int.parse(selectedYear!),
      months.indexOf(selectedMonth!) + 2,
      0,
    ).day;

    // 2. Trova la transazione massima (Assumendo che _transactions sia la tua lista di transazioni)
    double maxTransaction = _transactions.isEmpty
        ? 0.0
        : _transactions
            .map((transaction) => double.parse(transaction.amount))
            .reduce((double a, double b) => a > b ? a : b);

    // 3. Aggiungi un margine (ad esempio, il 10% del maxTransaction)
    double upperLimit = maxTransaction * 1.1;

    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: ListTile(
            title: Text("Hey! ${widget.userdata.name}!"),
            leading: ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(defaultRadius * 4)),
              child: Image.asset("assets/image/profile.jpeg"),
            ),
            trailing: const Icon(Icons.notifications),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Titolo
              Text(
                "${selectedMonth ?? 'Mese attuale'} ${selectedYear ?? 'Anno attuale'}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Grafico
              Container(
                height: 200,
                color: Colors.transparent,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    // Configurazione per l'asse X
                    minimum: 1,
                    maximum: double.parse(daysInMonth as String),
                  ),
                  primaryYAxis: NumericAxis(
                    // Configurazione per l'asse Y
                    minimum: 0,
                    maximum: upperLimit,
                  ),
                  // altri parametri...
                ),
              ),
              const SizedBox(height: 16),
              // Dropdowns per il mese e l'anno
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Anno
                  Expanded(
                    child: DropdownButton<String>(
                      menuMaxHeight: 300,
                      isExpanded: true,
                      value: selectedYear,
                      hint: const Text("Scegli l'anno"),
                      items: years.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue;
                          loadData();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Mese
                  Expanded(
                    child: DropdownButton<String>(
                      menuMaxHeight: 300,
                      isExpanded: true,
                      value: selectedMonth,
                      hint: const Text("Scegli il mese"),
                      items: months.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = newValue;
                          loadData();
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Lista delle transazioni
              const Text('Transazioni'),
              const SizedBox(height: 16),
              FutureBuilder<List<Transaction>>(
                future: DatabaseHelper.instance.getTransactionsForMonthAndYear(
                    selectedMonth!, selectedYear!, months),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child:
                          Text('Si è verificato un errore: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nessuna transazione disponibile.'),
                    );
                  } else {
                    List<Transaction> transactions = snapshot.data!;
                    transactions = List.from(transactions);
                    return Column(
                      children: transactions.map((transaction) {
                        return TransictionItemTitle(
                          transaction: transaction,
                          onReload: loadData,
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
      ],
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
