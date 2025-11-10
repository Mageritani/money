import 'package:money/model/transaction_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static final Databasehelper instance = Databasehelper._init();
  static Database? _database;
  Databasehelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("transaction.db");
    return _database!;
  }

  //初始化資料庫
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //建立資料庫
  Future _createDB(Database db, int version) async {
    await db.execute("""
      CREATE TABLE transactions (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       type TEXT NOT NULL,
       amount REAL NOT NULL,
       category TEXT NOT NULL,
       description TEXT NOT NULL,
       date TEXT NOT NULL,
       iconName TEXT NOT NULL,
       iconHax TEXT NOT NULL,
       )
""");
  }

  //新增交易
  Future<int> insert(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  //讀取所有交易
  Future<List<TransactionModel>> getAll() async {
    final db = await database;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  //讀取第n項的交易
  Future<List<TransactionModel>> getRecent(int limit) async {
    final db = await database;
    final result = await db.query(
      'transactions',
      orderBy: 'date DESC',
      limit: limit,
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  //根據日期讀取交易
  Future<List<TransactionModel>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final result = await db.query(
      'transactions',
      where: "date betrween ? AND ?",
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: "date DESC",
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  //計算總收入
  Future<double> getTotalIncome() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['income'],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  //計算總支出
  Future<double> getTotalExpense() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      ['expense'],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  //計算總餘額(收入－支出)
  Future<double> getTotalBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();
    return income - expense;
  }

  //更新交易
  Future<int> update(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  //刪除交易
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  //關閉資料庫
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
