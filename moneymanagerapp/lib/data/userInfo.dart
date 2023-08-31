enum TransactionType { uscita, entrata, none }

enum ItemCategoryType { cibo, svago, vestiario, sport, macchina, altro, none }

class UserInfo {
  String name;
  String totalBalance;
  String entrata;
  String uscita;
  List<Transaction> transactions;
  UserInfo(
      {required this.name,
      required this.totalBalance,
      required this.entrata,
      required this.uscita,
      required this.transactions});
}

class Transaction {
  final int? id;
  final ItemCategoryType categoryType;
  final TransactionType transactionType;
  final String itemCategoryName;
  final String itemName;
  final String amount;
  final String date;

  const Transaction(this.id, this.categoryType, this.transactionType,
      this.itemCategoryName, this.itemName, this.amount, this.date);
}

/*
const List<Transaction> transactions1 = [
  Transaction(ItemCategoryType.cibo, TransactionType.uscita, "Shoes",
      "Puma Sneaker", "€3,500.00", "Oct, 23"),
  Transaction(ItemCategoryType.cibo, TransactionType.uscita, "Bag",
      "Gucci Flax", "€10,500.00", "Sept, 13")
];

const List<Transaction> transactions2 = [
  Transaction(ItemCategoryType.vestiario, TransactionType.entrata, "vestiario",
      "Transfer from Eden", "€13,000.00", "Oct, 2"),
  Transaction(ItemCategoryType.svago, TransactionType.uscita, "Food",
      "Chicken Wing", "€1,500.00", "Oct, 18")
];
*/

UserInfo userdata = UserInfo(
    name: "Michelangelo",
    totalBalance: "€0",
    entrata: "€0",
    uscita: "€0",
    transactions: []);
