import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:moneymattersmobile/models/transaction.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/services/auth.dart';

//creating firebase instance
cloud_firestore.FirebaseFirestore firestore = cloud_firestore.FirebaseFirestore.instance;

//collections
cloud_firestore.CollectionReference<Map<String, dynamic>> userCollection = firestore.collection("users"),
transactionCollection = firestore.collection("transactions");

//handy filter function
List<T> filter<T>(dynamic list, bool Function(T item) filterFunc) =>
  list.any(filterFunc) ?
  list.where(filterFunc).toList() :
  [];


//firebase user CRUD
Future<List<User>> readUsers() async => (await userCollection
.snapshots().first).docs
  .map((doc) => User.fromJSON(doc.data())!)
  .toList();

void deleteUser(String id) => userCollection.doc(id).delete();


//firebase transaction CRUD
Future<String> setTransaction(cloud_firestore.DocumentReference<Map<String, dynamic>> transDoc, Transaction transaction) async {
  User? user = await getCurrUser();
  if (user == null) return "User not found";
  try {
    transaction.id = transDoc.id;
    transDoc.set(transaction.toJSON());
    return "Success";
  } on cloud_firestore.FirebaseException catch (e) { return e.message ?? "Error"; }
}

Future<Stream<List<Transaction>>> readTransactions() async {
  User? currUser = await getCurrUser();
  return transactionCollection
    .snapshots()
    .map((snapshot) => filter(
      snapshot.docs.map((doc) => Transaction.fromJSON(doc.data())),
      (Transaction trans) => trans.userId == (currUser?.id ?? "")
    ));
}

void deleteTransaction(String id) => transactionCollection.doc(id).delete();


//firebase miscellaneous functions
cloud_firestore.DocumentReference<Map<String, dynamic>> getUserDoc([String? uid]) => userCollection.doc(uid);

cloud_firestore.DocumentReference<Map<String, dynamic>> getTransactionDoc([String? uid]) => transactionCollection.doc(uid);