import 'package:flutter/material.dart';
import 'package:moneymanagerapp/components/navbar.dart';
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

    // Calcola la somma delle transazioni in uscita per ogni giorno
    Map<int, double> sumPerDay = {};
    for (var transaction in _transactions
        .where((t) => t.transactionType == TransactionType.uscita)) {
      String dateStr = transaction.date;
      int day = int.parse(dateStr.split('-')[0]);
      double amount = double.parse(transaction.amount);
      sumPerDay[day] = (sumPerDay[day] ?? 0) + amount;
    }

    // Trova il giorno con la somma massima
    double maxSum = sumPerDay.values.isNotEmpty
        ? sumPerDay.values.reduce((a, b) => a > b ? a : b)
        : 0.0;

    // Usa maxSum come limite superiore per l'asse Y
    double upperLimit = maxSum * 1.1; // Aggiungi un margine del 10%

    return ListView(
      shrinkWrap: true,
      children: [
        const Navbar(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${selectedMonth ?? 'Mese attuale'} ${selectedYear ?? 'Anno attuale'}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset.zero,
                            blurRadius: 5,
                            spreadRadius: 1),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border:
                          Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    child: InkWell(
                      onTap: () async {
                        String? selectedFormat = await _selectDate(context);
                        if (selectedFormat != null) {
                          // Usa la stringa come preferisci
                          print(selectedFormat); // Esempio
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.date_range,
                              color: Color.fromARGB(255, 0, 0, 0),
                              size: 24.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              "${selectedMonth ?? 'Mese attuale'} ${selectedYear ?? 'Anno attuale'}",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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

  Future<String?> _selectDate(BuildContext context) async {
    DateTime? pickedDate;
    String selectedFormat = "G, M e A"; // Imposta un valore predefinito

    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 365 * 100)),
      helpText: "Seleziona data",
      cancelText: 'Annulla',
      confirmText: 'OK',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 0, 0, 0),
            hintColor: const Color.fromARGB(255, 0, 0, 0),
            colorScheme:
                const ColorScheme.light(primary: Color.fromARGB(255, 0, 0, 0)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: child!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      selectedFormat = "Anno e Mese";
                      Navigator.pop(context, DateTime.now());
                    },
                    child: Text("Seleziona tutto il mese"),
                  ),
                  TextButton(
                    onPressed: () {
                      selectedFormat = "Solo Anno";
                      Navigator.pop(context, DateTime.now());
                    },
                    child: Text("Seleziona tutto l'anno"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((date) {
      pickedDate = date;
    });

    if (pickedDate != null) {
      if (selectedFormat == "Solo Anno") {
        return "${pickedDate?.year}";
      } else if (selectedFormat == "Anno e Mese") {
        return "${pickedDate?.month}/${pickedDate?.year}";
      } else {
        return "${pickedDate?.day}/${pickedDate?.month}/${pickedDate?.year}";
      }
    }
    return null;
  }
}
