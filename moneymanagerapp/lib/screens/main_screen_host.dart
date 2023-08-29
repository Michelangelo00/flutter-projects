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
        return const HomeScreenTab();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return const HomeProfileTab();
      default:
        return const HomeScreenTab();
    }
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tuo contenuto principale qui
          buildTabContent(currentIndex),
          // Posizionamento del FloatingActionButton
          Positioned(
            bottom: 10, // posizione dal fondo dello schermo
            right: 10, // posizione dalla destra dello schermo
            child: FloatingActionButton(
              onPressed: () {
                showAddTransactionDialog(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
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

  void showAddTransactionDialog(BuildContext context) {
    // variabili temporanee per memorizzare i dati della nuova transazione
    String newItemCategoryName = '';
    String newItemName = '';
    double newAmount = 0.0;
    ItemCategoryType newItemCategoryType = ItemCategoryType.fashion;
    TransactionType newTransictionType = TransactionType.inflow;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      items: ItemCategoryType.values
                          .map((ItemCategoryType category) {
                        return DropdownMenuItem<ItemCategoryType>(
                          value: category,
                          child: Text(category.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (ItemCategoryType? newValue) {
                        if (newValue != null) {
                          newItemCategoryType = newValue;
                        }
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
                      items: TransactionType.values.map((TransactionType type) {
                        return DropdownMenuItem<TransactionType>(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (TransactionType? newValue) {
                        if (newValue != null) {
                          newTransictionType = newValue;
                        }
                      },
                    ),
                  ),
                ],
              ),
              TextField(
                onChanged: (value) {
                  newItemName = value;
                },
                decoration: InputDecoration(labelText: 'Nome dell\'elemento'),
              ),
              TextField(
                onChanged: (value) {
                  newAmount = double.parse(value);
                },
                decoration: InputDecoration(labelText: 'Importo'),
                keyboardType: TextInputType.number,
              ),
              // ... altri campi
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Aggiungi la nuova transazione alla lista
                  transactions.add(Transaction(
                      newItemCategoryType, // <-- Nota: Devi convertire la stringa in un enum
                      newTransictionType, // <-- Nota: Devi convertire la stringa in un enum
                      newItemCategoryName,
                      newItemName,
                      newAmount
                          .toString(), // <-- Converte l'importo in una stringa
                      formattedDate // <-- Usa la data formattata
                      ));
                });
                Navigator.of(context).pop(); // chiude il dialog
              },
              child: const Text("Salva"),
            ),
          ],
        );
      },
    );
  }
}
