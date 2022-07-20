import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneymattersmobile/models/transaction.dart';
import 'package:moneymattersmobile/screenData.dart';
import 'package:moneymattersmobile/services/firebase.dart';
import 'package:moneymattersmobile/widgets/homeSecTitle.dart';
import 'package:moneymattersmobile/widgets/screenHeader.dart';

class ReportsScreen extends StatefulWidget {
  ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<int> daysList = List<int>.generate(31, (i) => i + 1);

  final double width = 7;

  BarChartGroupData makeGroupData(int x, double y1, [double? y2]) {
    List<BarChartRodData> barCharts = [
      BarChartRodData(
        toY: y1,
        color: y1 > 0 ? const Color(0xff53fdd7) : const Color(0xffff5182),
        width: width,
      ),
    ];
    if (y2 != null) {
      barCharts.add(
        BarChartRodData(
          toY: y2,
          color: y2 > 0 ? const Color(0xff53fdd7) : const Color(0xffff5182),
          width: width,
        )
      );
    }
    return BarChartGroupData(barsSpace: 1, x: x, barRods: barCharts);
  }

  @override
  Widget build(BuildContext context) {

      return StreamBuilder<List<Transaction>>(
        stream: readTransactions(),
        builder: (context, snapshot) {
          
          List<BarChartGroupData> barGroups = [];
          List<String> leftTitleList = [];
          int maxVal = 0,
          minVal = 0;
          List<String> bottomTitleList = daysList.map((e) => e % 10 == 0 || e == 1 ? e.toString() : "" ).toList();
          List filter(List list, bool Function(dynamic e) filterFunc) {
            return list.any(filterFunc) ? 
            list.where(filterFunc).toList():
            [];
          }

          if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
            List<Transaction> reportsTransactionList = snapshot.data!.where((e) => e.date.month == DateTime.now().month).toList();
            List<List<Transaction>> transactionsByDay = daysList
              .map((e) => filter(reportsTransactionList, (trans) => trans.date.day == e) as List<Transaction>)
              .toList();
            List<List<double>> transAmountsByDay = transactionsByDay
              .map((e) => e
              .map<double>((trans) => trans.amount)
              .toList())
              .toList();
            List<double> netIncomePerDay = transAmountsByDay
              .map((e) => e.isEmpty ? 0.0 : e
              .reduce((value, element) => value + element))
              .toList();
            List<Map<String, double>> netTransactionsByDay = transAmountsByDay
              .map((e) => e.isEmpty ? {
                "earn": 0.0,
                "expense": 0.0,
              } : {
                "earn": filter(e, (trans) => trans.amount > 0).reduce((value, element) => value + element) as double,
                "expenses": filter(e, (trans) => trans.amount < 0).reduce((value, element) => value + element) as double,
              })
              .toList();

            maxVal = netIncomePerDay.reduce(max).floor();
            minVal = netIncomePerDay.reduce(min).ceil();
            barGroups = daysList.map((e) => makeGroupData(e, netIncomePerDay[e - 1])).toList();
            leftTitleList.add("${minVal}");
            for (int i = minVal + 1; i < maxVal; i++) {
              leftTitleList.add(i % 10 == 0 ? i.toString() : "");
            }
            leftTitleList.add("${maxVal}");
          }
          else if (snapshot.hasError) {
            print(snapshot.error);
          }

          return ScreenHeader("Reports",
              Column(
                children: [
                  Column(
                    children: [
                      HomeSectionTitle("Net Income for ${monthList[DateTime.now().month]}"),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 400,
                        height: 200,
                        child: snapshot.connectionState == ConnectionState.active ? 
                        BarChart(
                            BarChartData(
                              barGroups: barGroups,
                              gridData: FlGridData(
                                checkToShowHorizontalLine: (value) => value % 5 == 0,
                                getDrawingHorizontalLine: (value) =>
                                  FlLine(
                                    color: value == 0 ? const Color(0xff363753) : const Color(0xff2a2747),
                                    strokeWidth: value == 0 ? 3.0 : 0.8,
                                  )
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    reservedSize: 30,
                                    showTitles: true,
                                    getTitlesWidget: (i, meta) => AutoSizeText(leftTitleList[i.toInt() - minVal], maxLines: 1, style: TextStyle(color: textColor),)
                                  )
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (i, meta) => Text(bottomTitleList[i.toInt() - 1], style: TextStyle(color: textColor),),
                                  )
                                )
                              ),
                            )
                        ) : Container(),
                      ),
                    ],
                  ),
                ],
              )
          );
        }
      );
    }
  }