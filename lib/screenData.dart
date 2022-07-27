import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymattersmobile/models/user.dart';

//for general use
List<String> monthList = [ "None", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
Map<String, List<String>> allCategories = {
  "Earn": ["Salary", "Investments(Earnt)", "Other(Earnt)"],
  "Expense": ["School", "F&B", "Transport", "Entertainment", "Investments(Expense)", "Medical", "Other(Expense)"],
};

//themes
ThemeMode theme = ThemeMode.dark;

//for sign in and register screens
const bgColour = Color(0xff191720);
const textFieldFill = Color(0xff1E1C24);
var headlines = GoogleFonts.poppins(textStyle: const TextStyle(
  color: Colors.white,
  fontSize: 34,
  fontWeight: FontWeight.w500
));
var bodyText = GoogleFonts.poppins(textStyle: const TextStyle(
    color: Colors.grey,
    fontSize: 15,
));
var buttonText = GoogleFonts.poppins(textStyle: const TextStyle(
    color: Colors.black87,
    fontSize:16,
    fontWeight: FontWeight.bold
));
var bodyText2 = GoogleFonts.poppins(textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.w500
));