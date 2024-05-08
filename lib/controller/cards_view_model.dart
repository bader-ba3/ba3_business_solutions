import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/old_model/seller_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/sellers/widget/all_seller_invoice_view_data_grid_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:math';
import '../old_model/card_model.dart';
import '../old_model/global_model.dart';
import 'user_management_model.dart';

class CardsViewModel extends GetxController {
  Map<String, CardModel> allCards = {};
  CardsViewModel() {
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

