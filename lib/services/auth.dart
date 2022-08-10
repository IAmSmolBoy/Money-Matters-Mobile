import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/services/firestore.dart';

firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;

//authentication
Future<String> login(String email, String password) async {
  try {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return "Success";
  } on firebase_auth.FirebaseException catch (e) {
    return e.message ?? "Error";
  }
}

Future<String> register(String username, String email, String password) async {
  String result = "Error";
  try {
    firebase_auth.UserCredential newAuthUser = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (newAuthUser.user != null) {
      await getUserDoc(newAuthUser.user?.uid ?? "").set(User(newAuthUser.user!.uid, username, email, password).toJSON());
      result = "Success";
    }
  } on firebase_auth.FirebaseException catch (e) {
    result = e.message ?? "Error";
  }
  return result;
}

Future<String> resetPass(String email) async {
  String result = "Error";
  try {
    await auth.sendPasswordResetEmail(email: email);
    result = "Check your email for the reset password email";
  } on firebase_auth.FirebaseException catch (e) {
    result = e.message ?? "Error";
  }
  return result;
}

//retrieving current user info
Future<User?> getCurrUser() async {
  firebase_auth.User? currUser = auth.currentUser;
  User? user;
  if ((currUser?.uid ?? "").isNotEmpty) {
    DocumentSnapshot doc = await firestore.collection("users")
      .doc(currUser?.uid)
      .get();
    user = doc.data() != null ? User.fromJSON(doc.data() as Map<String, dynamic>) : null;
  }
  return user;
}

firebase_auth.User? getCurrAuthUser() => auth.currentUser;

//other miscellaneous functions
void signOut() => auth.signOut();