import 'dart:async';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:moneymanagerapp/data/userInfo.dart';

class DatabaseHelper {
  static const _dbName = "moneyManagerDB.db";
  static const _dbVersion = 1;

  static const tableTransactions = "transactions";

  // rende questa classe singleton
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  sql.Database? _database;

  Future<sql.Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await sql.getDatabasesPath(), _dbName);
    return await sql.openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(sql.Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableTransactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoryType TEXT,
      transactionType TEXT,
      itemCategoryName TEXT,
      itemName TEXT,
      amount TEXT,
      date TEXT
    )
  ''');
  }

  Future<void> insertTransaction(Transaction transaction) async {
    sql.Database? db = await database;
    try {
      await db!.insert(
        tableTransactions,
        {
          'categoryType': transaction.categoryType.toString(),
          'transactionType': transaction.transactionType.toString(),
          'itemCategoryName': transaction.itemCategoryName,
          'itemName': transaction.itemName,
          'amount': transaction.amount,
          'date': transaction.date,
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error during insert: $e");
    }
  }

  Future<List<Transaction>> getTransactions() async {
    sql.Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(tableTransactions);

    return List.generate(maps.length, (i) {
      return Transaction(
        maps[i]['id'],
        ItemCategoryType.values.firstWhere(
            (e) => e.toString() == maps[i]['categoryType'],
            orElse: () => ItemCategoryType.none),
        TransactionType.values.firstWhere(
            (e) => e.toString() == maps[i]['transactionType'],
            orElse: () => TransactionType.none),
        maps[i]['itemCategoryName'],
        maps[i]['itemName'],
        maps[i]['amount'],
        maps[i]['date'],
      );
    });
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db!.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Transaction>> getTransactionsForMonthAndYear(
      String month, String year, List<String> months) async {
    sql.Database? db = await database;
    int monthIndex =
        months.indexOf(month) + 1; // Converti il nome del mese in numero
    String monthStr = monthIndex < 10 ? '0$monthIndex' : monthIndex.toString();

    // Query per la ricerca del mese e dell'anno
    final List<Map<String, dynamic>> maps = await db!.query(
      tableTransactions,
      where: "substr(date, 7, 4) = ? AND substr(date, 4, 2) = ?",
      whereArgs: [year, monthStr],
      orderBy: 'date DESC',
    );

    // Ritorna una lista di transazioni appartenenti a quel mese e quell'anno
    return List.generate(maps.length, (i) {
      return Transaction(
        maps[i]['id'],
        ItemCategoryType.values.firstWhere(
            (e) => e.toString() == maps[i]['categoryType'],
            orElse: () => ItemCategoryType.none),
        TransactionType.values.firstWhere(
            (e) => e.toString() == maps[i]['transactionType'],
            orElse: () => TransactionType.none),
        maps[i]['itemCategoryName'],
        maps[i]['itemName'],
        maps[i]['amount'],
        maps[i]['date'],
      );
    });
  }
}
