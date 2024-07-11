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
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8), border: Border.all()),
      width: 150,
      height: 40,
      child: InkWell(
          onTap: () {
            Get.defaultDialog(
                title: "اختر يوم",
                content: SizedBox(
                  height: MediaQuery.sizeOf(context).height/1.6,
                  width: MediaQuery.sizeOf(context).height/1,
                  child: SfDateRangePicker(
                    initialDisplayDate: DateTime.tryParse(widget.initDate ?? ""),
                    enableMultiView: true,
                    backgroundColor: Colors.transparent,
                    headerStyle: DateRangePickerHeaderStyle(backgroundColor: Colors.transparent),
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
                      child: Text("تم")),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("إلغاء"))
                ]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(widget.initDate != null
                    ? widget.initDate.toString().split(" ").first!
                    : date == null
                        ? "اختر يوم"
                        : date.toString().split(" ").first),
                Spacer(),
                Icon(Icons.date_range)
              ],
            ),
          )),
    );
  }
}
