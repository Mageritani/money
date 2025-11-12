import 'package:flutter/material.dart';
import 'package:money/database/databaseHelper.dart';
import 'package:money/model/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final db = Databasehelper.instance;

  List<TransactionModel> _transactions = [];
  double _totalIncome = 0;
  double _totalExpense = 0;
  double _total = 0;
  bool _isLoading = false;

  List<TransactionModel> get transactions => _transactions;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get total => _total;
  bool get isLoading => _isLoading;

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final all = await db.getAll();

      double income = 0;
      double expense = 0;

      for (var transaction in all) {
        if (transaction.type == 'income') {
          income += transaction.amount;
        } else {
          expense += transaction.amount;
        }
      }

      _transactions = all;
      _totalIncome = income;
      _totalExpense = expense;
      _total = income - expense;
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await db.insert(transaction);
    await loadTransactions(); // 自動重新載入
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await db.delete(id);
      await loadTransactions(); // 刪除後重新載入資料
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow; // 重新拋出錯誤,讓呼叫方處理
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await db.update(transaction);
      await loadTransactions(); // 更新後重新載入資料
    } catch (e) {
      print('Error updating transaction: $e');
      rethrow;
    }
  }

  // 取得特定日期範圍的交易
  List<TransactionModel> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _transactions.where((transaction) {
      return transaction.date.isAfter(startDate.subtract(Duration(days: 1))) &&
          transaction.date.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  // 取得特定類別的交易
  List<TransactionModel> getTransactionsByCategory(String category) {
    return _transactions
        .where((transaction) => transaction.category == category)
        .toList();
  }

  // 取得特定類型的交易 (income/expense)
  List<TransactionModel> getTransactionsByType(String type) {
    return _transactions
        .where((transaction) => transaction.type == type)
        .toList();
  }

  // 清空所有資料 (可用於測試或重置)
  Future<void> clearAllTransactions() async {
    try {
      // 需要在 DatabaseHelper 中實作 deleteAll 方法
      for (var transaction in _transactions) {
        if (transaction.id != null) {
          await db.delete(transaction.id!);
        }
      }
      await loadTransactions();
    } catch (e) {
      print('Error clearing transactions: $e');
      rethrow;
    }
  }
}
