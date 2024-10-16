import 'package:ba3_business_solutions/view/card_management/read_card_view.dart';
import 'package:ba3_business_solutions/view/card_management/write_card_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardManagementLayout extends StatelessWidget {
  const CardManagementLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الإدارة"),
        ),
        body: Column(
          children: [
            Item("قراءة بطاقة", () {
              Get.to(() => const ReadCardView());
            }),
            Item("تعديل بطاقة", () {
              Get.to(() => const WriteCardView());
            }),
            Item("حذف صلاحيات بطاقة", () {
              Get.to(() => const WriteCardView());
            }),
          ],
        ),
      ),
    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            )),
      ),
    );
  }
}
