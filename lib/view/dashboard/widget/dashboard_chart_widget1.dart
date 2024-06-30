import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/seller_model.dart';

class DashboardChartWidget1 extends StatefulWidget {
  DashboardChartWidget1({super.key,});


  final Color lineColor = Colors.red;
  final Color indicatorLineColor = Colors.yellow;
  final Color indicatorTouchedLineColor = Colors.yellow;
  final Color indicatorSpotStrokeColor = Colors.yellow.withOpacity(0.5);
  final Color indicatorTouchedSpotStrokeColor = Colors.black;
  final Color bottomTextColor = Colors.black;
  final Color bottomTouchedTextColor = Colors.black;
  final Color averageLineColor = Colors.green;
  final Color tooltipBgColor = Colors.grey;
  final Color tooltipTextColor = Colors.black;


  // List<double> get yValues => const [1.3, 1.5, 1.8, 1.5, 2.2, 1.8, 3];

  @override
  State createState() => _DashboardChartWidget1State();
}

class _DashboardChartWidget1State extends State<DashboardChartWidget1> {
  late double touchedValue;
  Map<int,SellerModel> listData = {};
  List<FlSpot> listStop = [];

  bool fitInsideBottomTitle = true;
  bool fitInsideLeftTitle = false;

  @override
  void initState() {
    touchedValue = -1;
    super.initState();
  }

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   if (value % 1 != 0) {
  //     return Container();
  //   }
  //   final style = TextStyle(
  //     color: Colors.black.withOpacity(0.5),
  //     fontSize: 10,
  //   );
  //   String text;
  //   switch (value.toInt()) {
  //     case 0:
  //       text = '';
  //       break;
  //     case 1:
  //       text = '1k calories';
  //       break;
  //     case 2:
  //       text = '2k calories';
  //       break;
  //     case 3:
  //       text = '3k calories';
  //       break;
  //     default:
  //       return Container();
  //   }
  //
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 6,
  //     fitInside: fitInsideLeftTitle
  //         ? SideTitleFitInsideData.fromTitleMeta(meta)
  //         : SideTitleFitInsideData.disable(),
  //     child: Text(text, style: style, textAlign: TextAlign.center),
  //   );
  // }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final isTouched = value == touchedValue;
    final style = TextStyle(
      color: isTouched ? widget.bottomTouchedTextColor : widget.bottomTextColor,
      fontWeight: FontWeight.bold,
    );

    return SideTitleWidget(
      space: 4,
      axisSide: meta.axisSide,
      fitInside: fitInsideBottomTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0)
          : SideTitleFitInsideData.disable(),
      child: Text(
       ( listData[value.toInt()]?.sellerName)??"",
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellersViewModel>(builder: (controller) {
      listStop.clear();
      List<SellerModel> a = controller.allSellers.values.toList();
      listData = Map.fromEntries(List.generate(a.length+1, (index){
        if(index == 0){
          return  MapEntry(0, SellerModel(sellerName: "",sellerRecord: []));
        }else{
         return MapEntry(index, a[index-1]);
        }
      }));
      listData[a.length+1]=SellerModel(sellerName: "",sellerRecord: []);
      listData.forEach((key, value) {
        if(value.sellerRecord!.isNotEmpty){
          listStop.add(FlSpot(key.toDouble(),value.sellerRecord!.map((e) => double.parse(e.selleRecAmount??"0"),).reduce((value, element) => value+element,)!));
        }else{
          listStop.add(FlSpot(key.toDouble(),0));
        }
      },);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Text(
            "المبيعات حسب الموظف",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          AspectRatio(
            aspectRatio: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 12),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    getTouchedSpotIndicator:
                        (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((spotIndex) {
                        final spot = barData.spots[spotIndex];
                        if (spot.x == 0 || spot.x == 6) {
                          return null;
                        }
                        return TouchedSpotIndicatorData(
                          FlLine(
                            color: widget.indicatorTouchedLineColor,
                            strokeWidth: 4,
                          ),
                          FlDotData(
                            getDotPainter: (spot, percent, barData, index) {
                              if (index.isEven) {
                                return FlDotCirclePainter(
                                  radius: 8,
                                  color: Colors.white,
                                  strokeWidth: 5,
                                  strokeColor:
                                  widget.indicatorTouchedSpotStrokeColor,
                                );
                              } else {
                                return FlDotSquarePainter(
                                  size: 16,
                                  color: Colors.white,
                                  strokeWidth: 5,
                                  strokeColor:
                                  widget.indicatorTouchedSpotStrokeColor,
                                );
                              }
                            },
                          ),
                        );
                      }).toList();
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => widget.tooltipBgColor,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          if (flSpot.x == 0 || flSpot.x == 6) {
                            return null;
                          }
                          TextAlign textAlign;
                          switch (flSpot.x.toInt()) {
                            case 1:
                              textAlign = TextAlign.left;
                              break;
                            case 5:
                              textAlign = TextAlign.right;
                              break;
                            default:
                              textAlign = TextAlign.center;
                          }

                          return LineTooltipItem(
                            '${listData[flSpot.x.toInt()]!.sellerName!} \n',
                            TextStyle(
                              color: widget.tooltipTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: flSpot.y.toString(),
                                style: TextStyle(
                                  color: widget.tooltipTextColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),

                            ],
                            textAlign: textAlign,
                          );
                        }).toList();
                      },
                    ),
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? lineTouch) {
                      if (!event.isInterestedForInteractions ||
                          lineTouch == null ||
                          lineTouch.lineBarSpots == null) {
                        setState(() {
                          touchedValue = -1;
                        });
                        return;
                      }
                      final value = lineTouch.lineBarSpots![0].x;

                      if (value == 0 || value == 6) {
                        setState(() {
                          touchedValue = -1;
                        });
                        return;
                      }

                      setState(() {
                        touchedValue = value;
                      });
                    },
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 1.8,
                        color: widget.averageLineColor,
                        strokeWidth: 3,
                        dashArray: [20, 10],
                      ),
                    ],
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isStepLineChart: true,
                      spots: listStop,
                      isCurved: false,
                      barWidth: 4,
                      color: widget.lineColor,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            widget.lineColor.withOpacity(0.5),
                            widget.lineColor.withOpacity(0),
                          ],
                          // stops: const [0.5, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        spotsLine: BarAreaSpotsLine(
                          show: true,
                          flLineStyle: FlLine(
                            color: widget.indicatorLineColor,
                            strokeWidth: 2,
                          ),
                          checkToShowSpotLine: (spot) {
                            if (spot.x == 0 || spot.x == listData.length) {
                              return false;
                            }

                            return true;
                          },
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          if (index.isEven) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: widget.indicatorSpotStrokeColor,
                            );
                          } else {
                            return FlDotSquarePainter(
                              size: 12,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: widget.indicatorSpotStrokeColor,
                            );
                          }
                        },
                        checkToShowDot: (spot, barData) {
                          return spot.x != 0 && spot.x == listData.length;
                        },
                      ),
                    ),
                  ],
                  minY: 0,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    checkToShowHorizontalLine: (value) => value % 1 == 0,
                    checkToShowVerticalLine: (value) => value % 1 == 0,
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return const FlLine(
                          color: Colors.cyan,
                          strokeWidth: 2,
                        );
                      } else {
                        return const FlLine(
                          color: Colors.orange,
                          strokeWidth: 0.5,
                        );
                      }
                    },
                    getDrawingVerticalLine: (value) {
                      if (value == 0) {
                        return const FlLine(
                          color: Colors.redAccent,
                          strokeWidth: 10,
                        );
                      } else {
                        return const FlLine(
                          color: Colors.green,
                          strokeWidth: 0.5,
                        );
                      }
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1000,
                        reservedSize: 46,
                        // getTitlesWidget: leftTitleWidgets,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: bottomTitleWidgets,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}