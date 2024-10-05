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
                title: "اختر فترة زمنية",
                content: SizedBox(
                  height: MediaQuery.sizeOf(context).height/1.6,
                  width: MediaQuery.sizeOf(context).height/1,
                  child: SfDateRangePicker(
                    initialDisplayDate: DateTime.tryParse(widget.initDate ?? ""),
                    enableMultiView: true,
                    backgroundColor: Colors.transparent,
                    headerStyle: const DateRangePickerHeaderStyle(backgroundColor: Colors.transparent,),
                    navigationDirection: DateRangePickerNavigationDirection.vertical,
                    selectionMode: DateRangePickerSelectionMode.range,
                    monthViewSettings: const DateRangePickerMonthViewSettings(enableSwipeSelection: false,viewHeaderStyle:DateRangePickerViewHeaderStyle(backgroundColor: Colors.transparent)),
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
                      child: const Text("اختر")),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("الغاء"))
                ]);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(widget.initDate != null
                    ? widget.initDate!
                    : date == null
                        ? "اختر فترة زمنية"
                        : gettext()),
                const Spacer(),
                const Icon(Icons.date_range)
              ],
            ),
          )),
    );
  }

  String gettext() {
    return "${date![0].toString().split(" ").first}  -->  ${date![1].toString().split(" ").first}";
  }
}
