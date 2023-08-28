enum TransactionType { outflow, inflow }

enum ItemCategoryType { fashion, grocery, payments }

class UserInfo {
  final String name;
  final String totalBalance;
  final String inflow;
  final String outflow;
  final List<Transaction> transactions;
  const UserInfo(
      {required this.name,
      required this.totalBalance,
      required this.inflow,
      required this.outflow,
      required this.transactions});
}

class Transaction {
  final ItemCategoryType categoryType;
  final TransactionType transactionType;
  final String itemCategoryName;
  final String itemName;
  final String amount;
  final String date;

  const Transaction(this.categoryType, this.transactionType,
      this.itemCategoryName, this.itemName, this.amount, this.date);
}

const List<Transaction> transactions1 = [
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Shoes", "Puma Sneaker", "€3,500.00", "Oct, 23"),
  Transaction(ItemCategoryType.fashion, TransactionType.outflow, "Bag", "Gucci Flax", "€10,500.00", "Sept, 13")
];

const List<Transaction> transactions2 = [
  Transaction(ItemCategoryType.payments, TransactionType.inflow, "Payments", "Transfer from Eden", "€13,000.00", "Oct, 2"),
  Transaction(ItemCategoryType.grocery, TransactionType.outflow, "Food", "Chicken Wing", "€1,500.00", "Oct, 18")
];

const userdata = UserInfo(
    name: "Michelangelo",
    totalBalance: "€4,586.00",
    inflow: "€4,000.00",
    outflow: "€2000.00",
    transactions: []);
