import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {

  String id, category, description;
  DateTime date;
  double amount;

  Transaction({required this.id, required this.category, required this.description, required this.date, required this.amount});

  static Transaction fromJSON(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    category: json["category"],
    description: json["description"],
    date: (json["date"] as Timestamp).toDate(),
    amount: json["amount"],
  );

  Map<String, dynamic> toJSON() => {
    "id": id,
    "category": category,
    "description": description,
    "date": date,
    "amount": amount,
  };

}