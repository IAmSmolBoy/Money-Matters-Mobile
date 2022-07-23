import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneymattersmobile/models/user.dart' as UserModel;

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

UserModel.User? getCurrUser() {
  String uid = FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.uid : "";
  UserModel.User? user;
  if (uid != "") {
    firestore.collection("users")
      .doc(uid)
      .get()
      .then((DocumentSnapshot doc) => user = doc.data() != null ? UserModel.User.fromJSON(doc.data() as Map<String, dynamic>) : null);
  }
  return user;
}