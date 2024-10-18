import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../core/network/error/error_handler.dart';
import '../../../core/network/error/failure.dart';
import '../../datasources/seller/seller_firestore_service.dart';
import '../../model/seller/seller_model.dart';

class SellersRepository {
  final SellersFireStoreService _sellersService;

  SellersRepository(this._sellersService);

  Stream<Map<String, SellerModel>> getAllSellers() {
    return _sellersService
        .getAllSellersStream()
        .map((snapshot) => {for (var doc in snapshot.docs) doc.id: SellerModel.fromJson(doc.data() as Map<String, dynamic>)});
  }

  Future<Either<Failure, Unit>> addSeller(SellerModel sellerModel) async {
    try {
      await _sellersService.addSeller(sellerModel);
      return const Right(unit);
    } catch (e) {
      log('error from addSeller: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, Unit>> deleteSeller(String? sellerId) async {
    try {
      await _sellersService.deleteSeller(sellerId);
      return const Right(unit);
    } catch (e) {
      log('error from deleteSeller: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, Unit>> updateSeller(SellerModel sellerModel) async {
    try {
      await _sellersService.updateSeller(sellerModel);
      return const Right(unit);
    } catch (e) {
      log('error from updateSeller: $e');
      return Left(ErrorHandler(e).failure);
    }
  }
}
