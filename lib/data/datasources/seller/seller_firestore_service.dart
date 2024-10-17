import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/generate_id.dart';
import '../../model/seller/seller_model.dart';

class SellersFireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _sellersCollection => _firestore.collection(AppConstants.sellersCollection);

  Stream<QuerySnapshot> getAllSellersStream() {
    return _sellersCollection.snapshots();
  }

  Future<void> addSeller(SellerModel sellerModel) async {
    sellerModel.sellerId = generateId(RecordType.sellers);
    await _sellersCollection.doc(sellerModel.sellerId).set(sellerModel.toJson());
  }

  Future<void> deleteSeller(String? sellerId) async {
    await _sellersCollection.doc(sellerId).delete();
  }

  Future<void> updateSeller(SellerModel sellerModel) async {
    await _sellersCollection.doc(sellerModel.sellerId).update(sellerModel.toJson());
  }
}
