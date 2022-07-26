import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/services/auth.dart';

firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

Future uploadPfp(File? photo) async {
  User? user = await getCurrUser();
  if (user == null) return "User not found";
  if (photo == null) return "Photo not found";
  firebase_storage.Reference storageRef = storage.ref("User ${user.id}");
  try {
    for (firebase_storage.Reference img in (await storageRef.listAll()).items) img.delete();
    await storageRef.putFile(photo);
  }
  on firebase_storage.FirebaseException catch (e) { return e.message; }
}

Future<String> getPfpLink() async {
  User? user = await getCurrUser();
  if (user == null) return "User not found";
  if (user.pfp?.isEmpty ?? true) return "Photo not found";
  try {
    return await storage.ref("User ${user.id}").getDownloadURL();
  }
  on firebase_storage.FirebaseException catch (e) { return e.message ?? "Error"; }
  catch(e) { return "Error"; }
}
