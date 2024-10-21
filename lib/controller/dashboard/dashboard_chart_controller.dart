import 'package:ba3_business_solutions/controller/seller/sellers_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/styling/app_colors.dart';
import '../../data/model/seller/seller_model.dart';

class DashboardChartController extends GetxController {
  late double touchedValue;
  Map<int, SellerModel> listData = {};
  List<FlSpot> listSpot = [];

  bool fitInsideBottomTitle = true;

  @override
  void onInit() {
    super.onInit();
    touchedValue = -1;
    generateChartData();
  }

  void generateChartData() {
    List<SellerModel> allSellers = Get.find<SellersController>()
        .allSellers
        .values
        .where((element) => element.sellerRecord?.firstOrNull != null)
        .toList();

    listData = Map.fromEntries(List.generate(allSellers.length + 1, (index) {
      if (index == 0) {
        return MapEntry(0, SellerModel(sellerName: "", sellerRecord: []));
      } else {
        return MapEntry(index, allSellers[index - 1]);
      }
    }));

    listData[allSellers.length + 1] = SellerModel(sellerName: "", sellerRecord: []);

    listSpot.clear();
    listData.forEach((key, value) {
      if (value.sellerRecord!.isNotEmpty) {
        List<SellerRecModel> records = value.sellerRecord!.where((element) {
          String date = element.selleRecInvDate.toString().split(" ")[0];
          String month = DateTime.now().toString().split("-")[1];
          return date.split("-")[1] == month;
        }).toList();

        if (records.isNotEmpty) {
          listSpot.add(FlSpot(
            key.toDouble(),
            records.map((e) => double.parse(e.selleRecAmount ?? "0")).reduce((value, element) => value + element),
          ));
        }
      } else {
        listSpot.add(FlSpot(key.toDouble(), 0));
      }
    });

    update();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final isTouched = value == touchedValue;
    final style = TextStyle(
      color: isTouched ? AppColors.bottomTouchedTextColor : AppColors.bottomTextColor,
      fontWeight: FontWeight.bold,
    );

    return SideTitleWidget(
      space: 4,
      axisSide: meta.axisSide,
      fitInside: fitInsideBottomTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0)
          : SideTitleFitInsideData.disable(),
      child: Text(
        (listData[value.toInt()]?.sellerName) ?? "",
        style: style,
      ),
    );
  }
}
