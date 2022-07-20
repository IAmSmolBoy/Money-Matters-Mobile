import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneymattersmobile/models/transaction.dart' as types;
import 'package:moneymattersmobile/models/user.dart';

Stream<List<User>> readUsers() => FirebaseFirestore.instance
.collection("users")
.snapshots()
.map((snapshot) => snapshot.docs
  .map((doc) => User.fromJSON(doc.data()))
  .toList()
);

Stream<List<types.Transaction>> readTransactions() => FirebaseFirestore.instance
.collection("transactions")
.snapshots()
.map((snapshot) => snapshot.docs
  .map((doc) => types.Transaction.fromJSON(doc.data()))
  .toList()
);