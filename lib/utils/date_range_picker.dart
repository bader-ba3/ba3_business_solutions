import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker extends StatefulWidget {
  final Function(List<DateTime>) onSubmit;
  final String? initDate;
  const DateRangePicker({super.key, required this.onSubmit, this.initDate});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  List<DateTime>? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all()),
      width: 250,
      height: 40,
      child: InkWell(
          onTap: () {
            Get.defaultDialog(
                title: "pick a date",
                content: SizedBox(
                  height: 700,
                  width: 700,
                  child: SfDateRangePicker(
                    initialDisplayDate: DateTime.tryParse(widget.initDate ?? ""),
                    enableMultiView: true,
                    backgroundColor: Colors.white,
                    headerStyle: DateRangePickerHeaderStyle(backgroundColor: Colors.white),
                    navigationDirection: DateRangePickerNavigationDirection.vertical,
                    selectionMode: DateRangePickerSelectionMode.range,
                    monthViewSettings: const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
                    showNavigationArrow: true,
                    navigationMode: DateRangePickerNavigationMode.scroll,
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      PickerDateRange _ = dateRangePickerSelectionChangedArgs.value as PickerDateRange;
                      if (_.startDate != null && _.endDate != null) {
                        date = [_.startDate!, _.endDate!];
                      }
                    },
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        if (date != null && date?.length == 2) {
                          widget.onSubmit(date!);
                        }
                        Get.back();
                        setState(() {});
                      },
                      child: Text("yes")),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("no"))
                ]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(widget.initDate != null
                    ? widget.initDate!
                    : date == null
                        ? "Pick a Date"
                        : gettext()),
                Spacer(),
                Icon(Icons.date_range)
              ],
            ),
          )),
    );
  }

  String gettext() {
    return date![0].toString().split(" ").first! + "  -->  " + date![1].toString().split(" ").first;
  }
}
