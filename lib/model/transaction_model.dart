import 'package:flutter/material.dart';

class TransactionModel {
  final int? id;
  final String type;
  double amount;
  final String category;
  final String desciption;
  final DateTime date;
  final String iconName;
  final String iconHax;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.desciption,
    required this.date,
    required this.iconName,
    required this.iconHax,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'description': desciption,
      'date': date.toIso8601String(),
      'iconName': iconName,
      'iconHax': iconHax,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      category: map['category'],
      desciption: map['description'],
      date: DateTime.parse(map['date']),
      iconName: map['iconName'],
      iconHax: map['iconHax'],
    );
  }

  TransactionModel copyWith({
    int? id,
    String? type,
    double? amount,
    String? category,
    String? desciption,
    DateTime? date,
    String? iconName,
    String? iconHax,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      desciption: desciption ?? this.desciption,
      date: date ?? this.date,
      iconName: iconName ?? this.iconName,
      iconHax: iconHax ?? this.iconHax,
    );
  }
}
