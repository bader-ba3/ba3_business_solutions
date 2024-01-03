import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onSubmit;
  final String? initDate;
  const DatePicker({super.key, required this.onSubmit, this.initDate});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

DateTime? date;

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all()),
      width: 150,
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
                    selectionMode: DateRangePickerSelectionMode.single,
                    monthViewSettings: const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
                    showNavigationArrow: true,
                    navigationMode: DateRangePickerNavigationMode.scroll,
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      DateTime _ = dateRangePickerSelectionChangedArgs.value as DateTime;
                      date = _;
                    },
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        if (date != null) {
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
                        : date.toString().split(" ").first),
                Spacer(),
                Icon(Icons.date_range)
              ],
            ),
          )),
    );
  }
}
