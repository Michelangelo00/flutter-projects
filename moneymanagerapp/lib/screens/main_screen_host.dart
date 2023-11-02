import 'package:flutter/material.dart';
import 'package:moneymanagerapp/data/userInfo.dart';
import 'package:moneymanagerapp/screens/home_profile_tab.dart';
import 'package:moneymanagerapp/screens/home_screen_tab.dart';
import 'package:moneymanagerapp/screens/home_stat_tab.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/widget/transiction_item_title.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:moneymanagerapp/utils/database_helper.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({super.key});

  @override
  State<MainScreenHost> createState() => _MainScreenHostState();
}

class _MainScreenHostState extends State<MainScreenHost> {
  List<Transaction> transactions = [];
  var currentIndex = 0;
  HomeScreenTab? homeScreenTab;
  HomeStatTab? homeStatTab;
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _reloadTransactions();
    homeScreenTab = HomeScreenTab(
        transactions: transactions,
        userdata: userdata,
        onReload: _reloadTransactions);
    initializeDateFormatting('it_IT', null);
  }

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return HomeScreenTab(
          transactions: transactions,
          userdata: userdata,
          onReload: _reloadTransactions,
        );
      case 1:
        return HomeStatTab(
            transactions: transactions,
            userdata: userdata,
            onReload: _reloadTransactions);
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return HomeScreenTab(
            transactions: transactions,
            userdata: userdata,
            onReload: _reloadTransactions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Opacity(
        opacity: 0.7,
        child: FloatingActionButton(
          onPressed: () {
            showAddTransactionDialog(context, addNewTransaction);
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: buildTabContent(currentIndex),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color.fromARGB(255, 69, 39, 241),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: fontLight,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stat"),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  void showAddTransactionDialog(
      BuildContext context,
      Function(
              ItemCategoryType, TransactionType, String, String, String, String)
          addTransaction) {
    // variabili temporanee per memorizzare i dati della nuova transazione
    String newItemCategoryName = '';
    String newItemName = '';
    double newAmount = 0.0;
    ItemCategoryType newItemCategoryType = ItemCategoryType.none;
    TransactionType newTransictionType = TransactionType.none;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm', 'it').format(now);
    String categoryErrorMessage = '';
    String transactionErrorMessage = '';
    bool useCurrentDate = true;
    String displayedDate = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      newItemCategoryName = value;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Nome della transazione'),
                  ),
                  TextField(
                    onChanged: (value) {
                      newItemName = value;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Descrizione della transazione'),
                  ),
                  // Dropdown per la selezione della categoria
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButton<ItemCategoryType>(
                          isExpanded: true,
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.arrow_drop_down),
                          ),
                          value: newItemCategoryType,
                          hint: const Text("Scegli la categoria"),
                          items: ItemCategoryType.values
                              .map((ItemCategoryType category) {
                            return DropdownMenuItem<ItemCategoryType>(
                              value: category,
                              child: category == ItemCategoryType.none
                                  ? const Text(
                                      "Scegli la categoria",
                                      overflow: TextOverflow
                                          .ellipsis, // Gestisci il troncamento del testo
                                    )
                                  : Text(category.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (ItemCategoryType? newValue) {
                            setState(() {
                              if (newValue != null) {
                                newItemCategoryType = newValue;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (categoryErrorMessage.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        categoryErrorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  // Dropdown per la selezione del tipo di transazione
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButton<TransactionType>(
                          isExpanded: true,
                          icon: const Padding(
                            padding: EdgeInsets.only(
                                left: 10), // Sposta l'icona a destra
                            child: Icon(Icons.arrow_drop_down),
                          ),
                          value: newTransictionType,
                          hint: const Text("Scegli la transazione"),
                          items: TransactionType.values
                              .map((TransactionType type) {
                            return DropdownMenuItem<TransactionType>(
                              value: type,
                              child: type == TransactionType.none
                                  ? const Text(
                                      "Scegli la transazione",
                                      overflow: TextOverflow
                                          .ellipsis, // Gestisci il troncamento del testo
                                    )
                                  : Text(type.toString().split('.').last),
                            );
                          }).toList(),
                          onChanged: (TransactionType? newValue) {
                            setState(() {
                              if (newValue != null) {
                                newTransictionType = newValue;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (transactionErrorMessage.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        transactionErrorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  TextField(
                    onChanged: (value) {
                      newAmount = double.parse(value);
                    },
                    decoration: const InputDecoration(labelText: 'Importo'),
                    keyboardType: TextInputType.number,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            useCurrentDate = false; // disattiva la checkbox
                          });
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDateTime,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(3000),
                          );
                          if (pickedDate != null) {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay.fromDateTime(selectedDateTime),
                            );
                            if (pickedTime != null) {
                              selectedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              formattedDate =
                                  DateFormat('dd-MM-yyyy HH:mm', 'it')
                                      .format(selectedDateTime);
                              setState(() {
                                displayedDate = formattedDate;
                              });
                            }
                          }
                        },
                        child: Text("Scegli data e ora"),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(115, 10),
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: useCurrentDate,
                            onChanged: (bool? value) {
                              setState(() {
                                useCurrentDate = value!;
                              });
                            },
                          ),
                          const Text(
                            'Usa data odierna',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Text(
                        "$displayedDate",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  bool isValid = true;

                  if (newItemCategoryType == ItemCategoryType.none) {
                    categoryErrorMessage = 'Scegli una categoria.';
                    isValid = false;
                  } else {
                    categoryErrorMessage = '';
                  }

                  if (newTransictionType == TransactionType.none) {
                    transactionErrorMessage = 'Scegli una transazione.';
                    isValid = false;
                  } else {
                    transactionErrorMessage = '';
                  }

                  setState(() {});
                  if (isValid) {
                    addTransaction(
                      newItemCategoryType,
                      newTransictionType,
                      newItemCategoryName,
                      newItemName,
                      newAmount.toString(),
                      formattedDate,
                    );
                    Navigator.of(context).pop();
                  } // chiude il dialog
                },
                child: const Text("Salva"),
              ),
            ],
          );
        });
      },
    );
  }

  void addNewTransaction(ItemCategoryType type, TransactionType transType,
      String categoryName, String itemName, String amount, String date) {
    setState(() {
      // Crea una nuova istanza della classe Transaction
      Transaction newTransaction = Transaction(
        null,
        type,
        transType,
        categoryName,
        itemName,
        amount,
        date,
      );

      // Inserisci la nuova transazione nel database
      DatabaseHelper.instance
          .insertTransaction(newTransaction)
          .then((_) {})
          .catchError((e) {
        print("Errore durante l'inserimento nel DB: $e");
      });

      double transactionAmount =
          double.parse(amount.replaceAll('€', '').trim());
      double currententrata = double.parse(
          userdata.entrata.replaceAll('€', '').trim().replaceAll(',', ''));
      double currentuscita = double.parse(
          userdata.uscita.replaceAll('€', '').trim().replaceAll(',', ''));

      if (transType == TransactionType.entrata) {
        currententrata += transactionAmount;
      } else if (transType == TransactionType.uscita) {
        currentuscita += transactionAmount;
      }

      userdata.entrata = formatCurrency(currententrata);
      userdata.uscita = formatCurrency(currentuscita);
      userdata.totalBalance = formatCurrency(currententrata - currentuscita);

      transactions.insert(
          0,
          Transaction(
            null,
            type,
            transType,
            categoryName,
            itemName,
            amount,
            date,
          ));
      _reloadTransactions();
      updateHomeScreenTab();
      updateHomeStatTab();
    });
  }

  void _reloadTransactions() async {
    List<Transaction> newTransactions =
        await DatabaseHelper.instance.getTransactions();
    double totalentrata = 0.0;
    double totaluscita = 0.0;

    for (Transaction t in newTransactions) {
      if (t.transactionType == TransactionType.entrata) {
        totalentrata += double.parse(t.amount);
      } else if (t.transactionType == TransactionType.uscita) {
        totaluscita += double.parse(t.amount);
      }
    }

    userdata.entrata = formatCurrency(totalentrata);
    userdata.uscita = formatCurrency(totaluscita);
    userdata.totalBalance = formatCurrency(totalentrata - totaluscita);
    setState(() {
      transactions = newTransactions;
    });
  }

  void updateHomeScreenTab() {
    setState(() {
      homeScreenTab = HomeScreenTab(
          transactions: transactions,
          userdata: userdata,
          onReload: _reloadTransactions);
    });
  }

  void updateHomeStatTab() {
    setState(() {
      homeStatTab = HomeStatTab(
          transactions: transactions,
          userdata: userdata,
          onReload: _reloadTransactions);
    });
  }

  String formatCurrency(double value) {
    final oCcy = NumberFormat("#,##0.00", "en_US");
    String formattedValue = oCcy
        .format(value.abs()); // prende il valore assoluto per la formattazione
    if (value < 0) {
      return '-€$formattedValue'; // inserisce il segno meno davanti al simbolo dell'euro
    } else {
      return '€$formattedValue';
    }
  }
}
