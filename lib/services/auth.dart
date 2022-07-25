import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:moneymattersmobile/models/user.dart';

Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
Auth.User? currUser = Auth.FirebaseAuth.instance.currentUser;

Future<User?> getCurrUser() async {
  User? user;
  if ((currUser?.uid ?? "").isNotEmpty) {
    DocumentSnapshot doc = await firestore.collection("users")
      .doc(currUser?.uid)
      .get();
    user = doc.data() != null ? User.fromJSON(doc.data() as Map<String, dynamic>) : null;
  }
  return user;
}

Auth.User? getCurrAuthUser() => currUser;