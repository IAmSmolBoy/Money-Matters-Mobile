import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymattersmobile/models/user.dart';
import 'package:moneymattersmobile/screens/addTasnactionScreen.dart';
import 'package:moneymattersmobile/screens/home.dart';
import 'package:moneymattersmobile/models/pageInfo.dart';
import 'package:moneymattersmobile/screens/reportsScreen.dart';

//for navbar
List<PageInfo> pageData = [
  PageInfo("Reports", Icons.assessment, ReportsScreen()),
  PageInfo("Home", Icons.home, HomeScreen()),
  PageInfo("Add Transaction", Icons.add, AddTransactionScreen()),
];

//for general use
List<String> monthList = [ "None", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];
Map<String, List<String>> allCategories = {
  "Earn": ["Salary", "Investments(Earnt)", "Other(Earnt)"],
  "Expense": ["School", "F&B", "Transport", "Entertainment", "Investments(Expense)", "Medical", "Other(Expense)"],
};

Color textColor = Colors.white;

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

//current user
User? currUser;