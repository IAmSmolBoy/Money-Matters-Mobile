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

      return FutureBuilder(
        future: readTransactions(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${snapshot.error}"))
            );
            return ScreenHeader("Reports", Container());
          }
          else {
            return StreamBuilder<List<Transaction>>(
              stream: snapshot.data,
              builder: (context, snapshot) {
                
                List<BarChartGroupData> barGroups = [];
                List<String> leftTitleList = [];
                int maxVal = 0,
                minVal = 0;
                List<String> bottomTitleList = daysList.map((e) => e % 10 == 0 || e == 1 ? e.toString() : "" ).toList();
                List<T> filter<T>(List<T> list, bool Function(dynamic e) filterFunc) {
                  return list.any(filterFunc) ? 
                  list.where(filterFunc).toList() :
                  <T>[];
                }
                double reduceOrNull(List<double> list, double Function(double first, double second) filterFunc) {
                  return list.isNotEmpty ? 
                  list.reduce(filterFunc) :
                  0.0;
                }
          
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                  List<Transaction> reportsTransactionList = snapshot.data!.where((e) => e.date.month == DateTime.now().month).toList();
                  List<List<Transaction>> transactionsByDay = daysList
                    .map<List<Transaction>>((e) => filter<Transaction>(reportsTransactionList, (trans) => trans.date.day == e))
                    .toList();
                  List<List<double>> transAmountsByDay = transactionsByDay
                    .map((e) => e
                    .map((trans) => trans.amount)
                    .toList())
                    .toList();
                  List<Map<String, double>> netTransactionsByDay = transAmountsByDay
                    .map((amt) => {
                        "earn": reduceOrNull(filter<double>(amt, (amount) => amount > 0), (value, element) => value + element),
                        "expense": reduceOrNull(filter<double>(amt, (amount) => amount < 0), (value, element) => value + element),
                      }
                    )
                    .toList();

                  maxVal = netTransactionsByDay.map((e) => e["earn"]!).reduce(max).floor();
                  minVal = netTransactionsByDay.map((e) => e["expense"]!).reduce(min).ceil();
                  // print("${maxVal}, ${minVal}");
                  barGroups = daysList.map((e) => makeGroupData(e, netTransactionsByDay[e - 1]["earn"]!, netTransactionsByDay[e - 1]["expense"])).toList();
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
                                  barTouchData: BarTouchData(
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: Colors.transparent,
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        return BarTooltipItem(
                                          '(${group.x}, ${rod.toY})',
                                          TextStyle(
                                            color: rod.toY > 0 ? const Color(0xff53fdd7) : const Color(0xffff5182),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        );
                                      }),
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
        }, 
      );
    }
  }