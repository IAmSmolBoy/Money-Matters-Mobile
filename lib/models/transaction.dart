import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {

  String id, userId, category, description;
  DateTime date;
  double amount;

  Transaction({required this.id, required this.userId, required this.category, required this.description, required this.date, required this.amount});

  static Transaction fromJSON(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    userId: json["userId"],
    category: json["category"],
    description: json["description"],
    date: (json["date"] as Timestamp).toDate(),
    amount: json["amount"],
  );

  Map<String, dynamic> toJSON() => {
    "id": id,
    "userId": userId,
    "category": category,
    "description": description,
    "date": date,
    "amount": amount,
  };

}