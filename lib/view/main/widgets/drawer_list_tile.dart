import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/global/global_controller.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.index,
    required this.press,
  });

  final String title;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(builder: (controller) {
      return InkWell(
        onTap: press,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
                child: Row(
              children: [
                const SizedBox(
                  width: 40,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ))),
      );
    });
  }
}
