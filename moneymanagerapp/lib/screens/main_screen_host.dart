import 'package:flutter/material.dart';
import 'package:moneymanagerapp/data/userInfo.dart';
import 'package:moneymanagerapp/screens/home_profile_tab.dart';
import 'package:moneymanagerapp/screens/home_screen_tab.dart';
import 'package:moneymanagerapp/utils/constants.dart';
import 'package:moneymanagerapp/widget/transiction_item_title.dart';
import 'package:intl/intl.dart';

class MainScreenHost extends StatefulWidget {
  const MainScreenHost({super.key});

  @override
  State<MainScreenHost> createState() => _MainScreenHostState();
}

class _MainScreenHostState extends State<MainScreenHost> {
  List<Transaction> transactions = [];
  var currentIndex = 0;

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return HomeScreenTab(transactions: transactions, userdata: userdata);
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return HomeScreenTab(transactions: transactions, userdata: userdata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTransactionDialog(context, addNewTransaction);
        },
        child: const Icon(Icons.add),
      ),
      body: buildTabContent(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: secondaryDark,
        unselectedItemColor: fontLight,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stat"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
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
    ItemCategoryType newItemCategoryType = ItemCategoryType.fashion;
    TransactionType newTransictionType = TransactionType.inflow;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            content: Column(
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
                          padding: EdgeInsets.only(left: 150),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        value: newItemCategoryType,
                        hint: const Text("Seleziona una categoria"),
                        items: ItemCategoryType.values
                            .map((ItemCategoryType category) {
                          return DropdownMenuItem<ItemCategoryType>(
                            value: category,
                            child: Text(category.toString().split('.').last),
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
                // Dropdown per la selezione del tipo di transazione
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButton<TransactionType>(
                        isExpanded: true,
                        icon: const Padding(
                          padding: EdgeInsets.only(
                              left: 150), // Sposta l'icona a destra
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        value: newTransictionType,
                        items:
                            TransactionType.values.map((TransactionType type) {
                          return DropdownMenuItem<TransactionType>(
                            value: type,
                            child: Text(type.toString().split('.').last),
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
                TextField(
                  onChanged: (value) {
                    newAmount = double.parse(value);
                  },
                  decoration: const InputDecoration(labelText: 'Importo'),
                  keyboardType: TextInputType.number,
                ),
                // ... altri campi
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  addTransaction(
                    newItemCategoryType,
                    newTransictionType,
                    newItemCategoryName,
                    newItemName,
                    newAmount.toString(),
                    formattedDate,
                  );
                  Navigator.of(context).pop(); // chiude il dialog
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
      transactions.insert(
          0,
          Transaction(
            type,
            transType,
            categoryName,
            itemName,
            amount,
            date,
          ));
      // Usa NumberFormat per formattare le cifre
      final oCcy = NumberFormat("#,##0.00", "en_US");

      double transactionAmount = double.parse(amount);
      double currentInflow =
          double.parse(userdata.inflow.substring(1).replaceAll(',', ''));
      double currentOutflow =
          double.parse(userdata.outflow.substring(1).replaceAll(',', ''));

      if (transType == TransactionType.inflow) {
        currentInflow += transactionAmount;
      } else if (transType == TransactionType.outflow) {
        currentOutflow += transactionAmount;
      }

      userdata.inflow = '€${oCcy.format(currentInflow)}';
      userdata.outflow = '€${oCcy.format(currentOutflow)}';
      userdata.totalBalance = '€${oCcy.format(currentInflow - currentOutflow)}';
    });
  }
}
