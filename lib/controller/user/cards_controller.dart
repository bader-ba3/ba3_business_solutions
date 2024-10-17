import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/model/user/card_model.dart';

class CardsController extends GetxController {
  Map<String, CardModel> allCards = {};

  CardsController() {
    getAllCard();
  }

  void getAllCard() {
    FirebaseFirestore.instance.collection("Cards").snapshots().listen((event) {
      allCards.clear();
      for (var element in event.docs) {
        allCards[element.id] = CardModel.fromJson(element.data());
      }
      update();
    });
  }
}
