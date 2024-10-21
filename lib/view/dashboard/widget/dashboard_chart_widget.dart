import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/core/styling/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/dashboard/dashboard_chart_controller.dart';
import '../../../controller/seller/sellers_controller.dart';

class DashboardChartWidget extends StatelessWidget {
  const DashboardChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardChartController());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(25),
        child: GetBuilder<SellersController>(builder: (sellersController) {
          return GetBuilder<DashboardChartController>(builder: (controller) {
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 10),
                  const Text(
                    "المبيعات حسب الموظف",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const VerticalSpace(18),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: Get.width * 2,
                      height: 700,
                      padding: const EdgeInsets.symmetric(vertical: 70),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 12),
                        child: LineChart(
                          LineChartData(
                            lineTouchData: LineTouchData(
                              getTouchedSpotIndicator: (barData, spotIndexes) {
                                return spotIndexes.map((index) {
                                  final spot = barData.spots[index];
                                  if (spot.x == 0 || spot.x == 6) {
                                    return null;
                                  }
                                  return TouchedSpotIndicatorData(
                                    const FlLine(
                                      color: AppColors.indicatorTouchedLineColor,
                                      strokeWidth: 4,
                                    ),
                                    FlDotData(
                                      getDotPainter: (spot, percent, barData, index) {
                                        if (index.isEven) {
                                          return FlDotCirclePainter(
                                            radius: 8,
                                            color: Colors.white,
                                            strokeWidth: 5,
                                            strokeColor: AppColors.indicatorTouchedSpotStrokeColor,
                                          );
                                        } else {
                                          return FlDotSquarePainter(
                                            size: 16,
                                            color: Colors.white,
                                            strokeWidth: 5,
                                            strokeColor: AppColors.indicatorTouchedSpotStrokeColor,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }).toList();
                              },
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (touchedSpot) => AppColors.tooltipBgColor,
                                getTooltipItems: (spots) {
                                  return spots.map((barSpot) {
                                    final flSpot = barSpot;
                                    if (flSpot.x == 0 || flSpot.x == 6) return null;
                                    return LineTooltipItem(
                                      '${controller.listData[flSpot.x.toInt()]!.sellerName!} \n',
                                      const TextStyle(
                                        color: AppColors.tooltipTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: flSpot.y.toString(),
                                          style: const TextStyle(
                                            color: AppColors.tooltipTextColor,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                isStepLineChart: true,
                                spots: controller.listSpot,
                                isCurved: false,
                                barWidth: 4,
                                color: AppColors.lineColor,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.lineColor.withOpacity(0.5),
                                      AppColors.lineColor.withOpacity(0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  spotsLine: const BarAreaSpotsLine(
                                    show: true,
                                    flLineStyle: FlLine(
                                      color: AppColors.indicatorLineColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.black),
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: 1,
                                  getTitlesWidget: controller.bottomTitleWidgets,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        }),
      ),
    );
  }
}
