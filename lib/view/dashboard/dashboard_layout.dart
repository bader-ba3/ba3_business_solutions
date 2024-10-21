import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_chart_widget.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_header_widget.dart';
import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DashboardHeaderWidget(),
        DashboardChartWidget(),
      ],
    );
  }
}
