import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/services/auth.dart';
import 'package:moneymattersmobile/services/firestore.dart';
import 'package:moneymattersmobile/services/storage.dart';
import 'package:moneymattersmobile/widgets/editProfileWidgets/editProfileTextField.dart';
import 'package:moneymattersmobile/widgets/screenFormat.dart';
import 'package:path/path.dart';

class EditProfileScreen extends StatefulWidget  {

  void Function(void Function()) settingsSetState;
  
  EditProfileScreen({required this.settingsSetState, Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? currUser;

  TextEditingController usernameController = TextEditingController(),
  emailController = TextEditingController(),
  passwordController = TextEditingController();

  GlobalKey<FormState> editProfileForm = GlobalKey<FormState>();

  String username = "", email = "", password = "";
  String? currPfpURL;
  File? pfpImg;

  @override
  void initState() {
    getCurrUser().then(
      (user) {
        setState(() {
          usernameController.text = user?.username ?? "";
          emailController.text = user?.email ?? "";
          passwordController.text = user?.password ?? "";
        });
      }
    );

    super.initState();
  }
  
  Future uploadFile(File? photo) async {
    if (photo == null) return;
    // final fileName = basename(photo.path);
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('pfp');
      await ref.putFile(photo);
    } catch (e) {
      print('error occured');
    }
  }

  Future<void> selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        pfpImg = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrUser(),
      builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.hasError) {
          print(userSnapshot.error);
        } else if (userSnapshot.hasData) {
          currUser = userSnapshot.data;
        }
        return FutureBuilder<String?>(
          future: getPfpLink(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            } else if (snapshot.hasData) {
              currPfpURL = snapshot.data;
            }
            return ScreenFormat(
              userSnapshot.connectionState != ConnectionState.done || snapshot.connectionState != ConnectionState.done ?
              const Center(child: CircularProgressIndicator())
              : Container(
                padding: EdgeInsets.fromLTRB(
                  16, 25, 16, MediaQuery.of(context).viewInsets.bottom
                ),
                child: GestureDetector(
                  onTap: () { FocusScope.of(context).unfocus(); },
                  child: Form(
                    key: editProfileForm,
                    child: ListView(
                      children: [
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 4,
                                    color: Colors.transparent,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 10)),
                                  ],
                                  shape: BoxShape.circle,
                                ),
                                child: currUser != null && (currUser?.pfp ?? "").isNotEmpty || pfpImg != null ?
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      padding: EdgeInsets.zero,
                                      side: const BorderSide(width: 0,),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(130)
                                      ),
                                    ),
                                    onPressed: selectImage,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(130),
                                      child: pfpImg != null ?
                                      Image(
                                        image: FileImage(pfpImg!),
                                        height: 130,
                                        width: 130,
                                        fit: BoxFit.cover,
                                      ) :
                                      Image.network(
                                        currPfpURL ?? "",
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  ) :
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.account_circle_outlined,
                                      size: 130,
                                      color: textColor,
                                    ),
                                    onPressed: selectImage,
                                  ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )
                                )
                              )
                            ],
                          ),
                        ),
                        EditProfileTextField(
                          labelText: "Username",
                          onSavedFunc: (String? val) => username = val ?? "",
                          controller: usernameController,
                        ),
                        EditProfileTextField(
                          labelText: "Email",
                          onSavedFunc: (String? val) => email = val ?? "",
                          validator: (String? val) => !EmailValidator.validate(val ?? "")
                            ? "Enter a valid email"
                            : null,
                          controller: emailController,
                        ),
                        EditProfileTextField(
                          labelText: "Password",
                          onSavedFunc: (String? val) => password = val ?? "",
                          password: true,
                          controller: passwordController,
                        ),
                        const SizedBox(
                          height: 200,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  side: BorderSide(color: textColor),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: textColor,
                                  ),
                                )),
                            ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 2,
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () async {
                                firebase_auth.User? firebaseUser = getCurrAuthUser();
                                User? user = await getCurrUser();
                                if (firebaseUser == null || user == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("User not found"),
                                    )
                                  );
                                  return;
                                }
                                if (editProfileForm.currentState != null && editProfileForm.currentState!.validate()) {
                                  editProfileForm.currentState!.save();
                                  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar = ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saving")));
                                  try {
                                    await firebaseUser.updateEmail(email);
                                    await firebaseUser.updatePassword(password);
                                    String? res;
                                    if (pfpImg != null) res = await uploadPfp(pfpImg);
                                    if (res != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
                                    } else {
                                      User updatedUser = User(user.id, username, email, password, basename(pfpImg?.path ?? ""));
                                      getUserDoc(user.id).update(updatedUser.toJSON());
                                      widget.settingsSetState(() {});
                                      snackbar.close();
                                      Navigator.pop(context);
                                    }
                                  }
                                  on firebase_auth.FirebaseException catch (e) {
                                    if (e.message != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              settingsFunc: () => Navigator.pop(context),
            );
          }
        );
      },
    );
  }
}
