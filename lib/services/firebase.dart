import 'package:cloud_firestore/cloud_firestore.dart' as Firestore;
import 'package:moneymattersmobile/models/transaction.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/services/auth.dart';

Firestore.FirebaseFirestore firestore = Firestore.FirebaseFirestore.instance;
Firestore.CollectionReference<Map<String, dynamic>> userCollection = firestore.collection("users");

Stream<List<User>> readUsers() => userCollection
.snapshots()
.map((snapshot) => snapshot.docs
  .map((doc) => User.fromJSON(doc.data())!)
  .toList()
);

Firestore.DocumentReference<Map<String, dynamic>> getUserDoc(String uid) => userCollection.doc(uid);

Future<Stream<List<Transaction>>> readTransactions() async {
  User? currUser = await getCurrUser();
  List<T> filter<T>(dynamic list, bool Function(T item) filterFunc) =>
    list.any(filterFunc) ?
    list.where(filterFunc).toList() :
    [];
  return firestore
    .collection("transactions")
    .snapshots()
    .map((snapshot) => filter(
      snapshot.docs.map((doc) => Transaction.fromJSON(doc.data())),
      (Transaction trans) => trans.userId == (currUser?.id ?? "")
    ));
}