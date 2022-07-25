import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:moneymattersmobile/models/transaction.dart' as transModel;
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/services/firebase.dart';
import 'package:moneymattersmobile/widgets/filterDropdown.dart';
import 'package:moneymattersmobile/widgets/homeListViewTile.dart';
import 'package:moneymattersmobile/widgets/homeSecTitle.dart';
import 'package:moneymattersmobile/widgets/screenHeader.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Sort variables
  String sortBy = "Date";
  void changeSortBy(sortStr) {
    setState(() {
      sortBy = sortStr;
    });
  }

  //filter values
  int filterMonth = DateTime.now().month;
  String filterCategory = "None";
  List<String> homeFilterCatList =
      allCategories.values.expand((e) => e).toList();

  _HomeScreenState() {
    //home transaction list
    homeFilterCatList.insert(0, "None");
  }

  @override
  Widget build(BuildContext context) {

    //category filter dropdown on changed function
    void filterByCategory(int newCategoryIndex) {
      setState(() {
        filterCategory = homeFilterCatList[newCategoryIndex];
      });
    }
    List<transModel.Transaction> transactionListViewList = [];

    return FutureBuilder(
      future: readTransactions(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
            Future.delayed(Duration.zero,(){ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${snapshot.error}"))
            );
          });
          return ScreenHeader("Reports", Container());
        }
        else {
          return StreamBuilder<List<transModel.Transaction>>(
            stream: snapshot.data,
            builder: (context, snapshot) {
              List<transModel.Transaction> filter(filterFunc) =>
                  transactionListViewList = snapshot.data!.any(filterFunc)
                      ? snapshot.data!.where(filterFunc).toList()
                      : [];
              void updateHomeList() {
                transactionListViewList =
                    filterCategory == "None" && filterMonth == 0
                        ? snapshot.data!
                        : filterCategory == "None"
                            ? filter((transModel.Transaction e) => e.date.month == filterMonth)
                            : filterMonth == 0
                                ? filter((transModel.Transaction e) => e.category == filterCategory)
                                : filter((transModel.Transaction e) =>
                                    e.date.month == filterMonth &&
                                    e.category == filterCategory);
                  // print(transactionListViewList.map((e) => e.date.toString()));
              }
              void changeMonth(int newMonth) => setState(() {
                filterMonth = newMonth;
                updateHomeList();
              });
              if (snapshot.hasData) {
                transactionListViewList = snapshot.data!;
                updateHomeList();
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }
              void deleteTransaction (int i) {
                DocumentReference transaction = FirebaseFirestore.instance
                  .collection("transactions")
                  .doc(transactionListViewList[i].id);
                transaction.delete();
                transactionListViewList.removeAt(i);
              }
      
              return ScreenHeader(
                "Transactions",
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      // print("a $transactionListViewList");
                      return [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeSectionTitle("This Month"),
                              transactionListViewList.isNotEmpty
                                  ? ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 167,
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (c, i) {
                                          // print(transactionListViewList.map((e) => e.id,));
                                          return HomeListTile(
                                            i,
                                            c,
                                            deleteTransaction,
                                            DateTime.now().month,
                                            transactionListViewList,
                                            setState,
                                          );
                                        },
                                        separatorBuilder: (c, i) => const SizedBox(
                                          height: 1,
                                        ),
                                        itemCount: transactionListViewList.length,
                                      ))
                                  : Container()
                            ],
                          ),
                          // SortBySection(changeSortBy, sortBy),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeSectionTitle("Filter"),
                              FilterDropdown("Month: ", monthList, changeMonth,
                                  DateTime.now().month),
                              FilterDropdown("Category: ", homeFilterCatList,
                                  filterByCategory),
                            ],
                          ),
                        ][i];
                        },
                    separatorBuilder: (context, i) => const Divider(
                          thickness: 1,
                          color: Color(0xFFF8F9FA),
                        ),
                    itemCount: 2),
              );
            }
          );
        }
      }
    );
  }
}
