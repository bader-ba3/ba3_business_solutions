import 'package:ba3_business_solutions/controller/user/cards_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/model/user/card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

class ReadCardView extends StatefulWidget {
  const ReadCardView({super.key});

  @override
  State<ReadCardView> createState() => _ReadCardViewState();
}

class _ReadCardViewState extends State<ReadCardView> {
  CardsController cardsViewController = Get.find<CardsController>();

  String? cardId;
  String? userId;
  CardModel? cardModel;

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      print(tag.data);
      List<int> idList = tag.data["ndef"]['identifier'];
      String id = '';
      for (var e in idList) {
        if (id == '') {
          id = e.toRadixString(16).padLeft(2, "0");
        } else {
          id = "$id:${e.toRadixString(16).padLeft(2, "0")}";
        }
      }
      cardId = id.toUpperCase();
      if (cardsViewController.allCards.containsKey(cardId)) {
        cardModel = cardsViewController.allCards[cardId]!;
        Get.back();
        setState(() {});
      } else {
        Get.back();
        Get.back();
        Get.snackbar("خطأ", "غير مدخلة");
      }
      print(cardId);
      NfcManager.instance.stopSession();
    });
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then((value) => {
              Get.defaultDialog(
                  title: "جارِ قراءة البطاقة",
                  content: const Text("يرجى تقريب البطاقة"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("إلغاء"))
                  ])
            });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: cardModel == null
              ? const Text("هذه البطاقة غير معرفة")
              : Column(
                  children: [
                    const Text("رقم البطاقة",
                        style: TextStyle(fontSize: 22),
                        textDirection: TextDirection.ltr),
                    const SizedBox(height: 10),
                    Text(cardModel!.cardId.toString(),
                        style: const TextStyle(fontSize: 22),
                        textDirection: TextDirection.ltr),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "صالحة لدخول الحساب",
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      getUserNameById(cardModel!.userId.toString()),
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "تم إلغائها؟ ",
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      cardModel!.isDisabled! ? "نعم" : "لا",
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
