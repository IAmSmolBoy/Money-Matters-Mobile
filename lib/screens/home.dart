import "package:flutter/material.dart";
import 'package:moneymattersmobile/models/transaction.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/services/firestore.dart';
import 'package:moneymattersmobile/widgets/homeWidgets/filterDropdown.dart';
import 'package:moneymattersmobile/widgets/homeWidgets/homeListViewTile.dart';
import 'package:moneymattersmobile/widgets/homeWidgets/homeSecTitle.dart';
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
  // int filterMonth = DateTime.now().month;
  // String filterCategory = "None";
  List<String> homeFilterCatList =
      allCategories.values.expand((e) => e).toList();

  _HomeScreenState() {
    homeFilterCatList.insert(0, "None");
  }

  @override
  Widget build(BuildContext context) {

    List<Transaction> transactionListViewList = [];

    return FutureBuilder(
      future: readTransactions(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> transListSnapshot) {
        if (transListSnapshot.hasError) {
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${transListSnapshot.error}"))
              );
            }
          );
          return ScreenHeader("Reports", Container());
        }
        else {
          return StreamBuilder<List<Transaction>>(
            stream: transListSnapshot.data,
            builder: (context, snapshot) {
              List<Transaction> filter(filterFunc) =>
                transactionListViewList = snapshot.data!.any(filterFunc)
                  ? snapshot.data!.where(filterFunc).toList()
                  : [];
              void updateHomeList() {
                transactionListViewList =
                  filterCategory == "None" && filterMonth == 0
                    ? snapshot.data!
                    : filterCategory == "None"
                      ? filter((Transaction e) => e.date.month == filterMonth)
                      : filterMonth == 0
                        ? filter((Transaction e) => e.category == filterCategory)
                        : filter((Transaction e) =>
                          e.date.month == filterMonth &&
                          e.category == filterCategory
                        );
              }
              void changeMonth(int newMonth) => setState(() {
                filterMonth = newMonth;
                updateHomeList();
              });
              void filterByCategory(int newCategoryIndex) {
                setState(() {
                  filterCategory = homeFilterCatList[newCategoryIndex];
                  updateHomeList();
                });
              }
              void delTrans (int i) {
                deleteTransaction(transactionListViewList[i].id);
                transactionListViewList.removeAt(i);
              }

              if (snapshot.hasData) {
                transactionListViewList = snapshot.data!;
                updateHomeList();
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }
      
              return transListSnapshot.connectionState != ConnectionState.done || snapshot.connectionState != ConnectionState.active ?
                const Center(child: CircularProgressIndicator())
              : ScreenHeader(
                "Transactions",
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeSectionTitle(filterMonth != 0 ? monthList[filterMonth] : filterCategory != "None" ? filterCategory : "All Transactions"),
                              transactionListViewList.isNotEmpty
                                ? ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 167,
                                    ),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemBuilder: (c, i) {
                                        return HomeListTile(
                                          i,
                                          c,
                                          delTrans,
                                          DateTime.now().month,
                                          transactionListViewList,
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
                              FilterDropdown("Month: ", monthList, changeMonth, filterMonth),
                              FilterDropdown("Category: ", homeFilterCatList, filterByCategory,  homeFilterCatList.indexOf(filterCategory)),
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
