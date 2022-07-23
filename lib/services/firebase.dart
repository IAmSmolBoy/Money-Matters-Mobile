import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneymattersmobile/models/transaction.dart' as trans_model;
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screenData.dart';

Stream<List<User>> readUsers() => FirebaseFirestore.instance
.collection("users")
.snapshots()
.map((snapshot) => snapshot.docs
  .map((doc) => User.fromJSON(doc.data())!)
  .toList()
);

Future<Stream<List<trans_model.Transaction>>> readTransactions() async {
  User currUser = (await getUser())!;
  return FirebaseFirestore.instance
    .collection("transactions")
    .snapshots()
    .map((snapshot) => snapshot.docs
      .any((doc) => trans_model.Transaction.fromJSON(doc.data()).userId == currUser.id) ? snapshot.docs
      .where((doc) => trans_model.Transaction.fromJSON(doc.data()).userId == currUser.id)
      .map((doc) => trans_model.Transaction.fromJSON(doc.data()))
      .toList() : []
    );
}