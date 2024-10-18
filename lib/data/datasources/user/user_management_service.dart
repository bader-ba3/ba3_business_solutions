import 'package:ba3_business_solutions/core/network/error/error_handler.dart';
import 'package:ba3_business_solutions/core/network/error/failure.dart';
import 'package:ba3_business_solutions/data/model/user/card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../model/user/role_model.dart';
import '../../model/user/user_model.dart';

class UserManagementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all roles from Firestore
  Future<Map<String, RoleModel>> fetchAllRoles() async {
    final rolesSnapshot = await _firestore.collection(AppConstants.roleCollection).get();
    final Map<String, RoleModel> roles = {};
    for (var element in rolesSnapshot.docs) {
      roles[element.id] = RoleModel.fromJson(element.data());
    }
    return roles;
  }

  // Fetch user by PIN
  Future<UserModel?> fetchUserByPin(String userPin) async {
    final userSnapshot = await _firestore.collection(AppConstants.usersCollection).where('userPin', isEqualTo: userPin).get();
    if (userSnapshot.docs.isNotEmpty) {
      return UserModel.fromJson(userSnapshot.docs.first.data());
    }
    return null;
  }

  // Fetch card by card number
  Future<CardModel?> fetchCardByNumber(String cardNumber) async {
    final cardSnapshot = await _firestore.collection('Cards').where('cardId', isEqualTo: cardNumber).get();
    if (cardSnapshot.docs.isNotEmpty) {
      return CardModel.fromJson(cardSnapshot.docs.first.data());
    }
    return null;
  }

  // Fetch user by ID
  Future<UserModel?> fetchUserById(String? userId) async {
    final userDoc = await _firestore.collection(AppConstants.usersCollection).doc(userId).get();
    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data()!);
    }
    return null;
  }

  // Add or update a user
  Future<void> saveUser(UserModel user) {
    return _firestore.collection(AppConstants.usersCollection).doc(user.userId).set(user.toJson());
  }

  // Add or update a role
  Future<void> saveRole(RoleModel role) {
    return _firestore.collection(AppConstants.roleCollection).doc(role.roleId).set(role.toJson(), SetOptions(merge: true));
  }

  // Log user's time report
  Future<void> logTimeReport({required String userId, required DateTime date}) {
    return _firestore.collection(AppConstants.usersCollection).doc(userId).set({
      "userDateList": FieldValue.arrayUnion([date]),
      "userStatus": AppConstants.userStatusAway,
    }, SetOptions(merge: true));
  }

  // Start user's time report
  Future<void> startTimeReport(String userId, DateTime customDate) async {
    await _firestore.collection(AppConstants.usersCollection).doc(userId).set({
      "userDateList": FieldValue.arrayUnion([customDate]),
    }, SetOptions(merge: true));

    await _firestore.collection(AppConstants.usersCollection).doc(userId).set({
      "userStatus": AppConstants.userStatusAway,
    }, SetOptions(merge: true));
  }

  // Send user's time report
  Future<void> sendTimeReport(String userId, int? customTime) async {
    final userDoc = await _firestore.collection(AppConstants.usersCollection).doc(userId).get();
    if (userDoc.exists) {
      final userData = userDoc.data();
      DateTime model = (userData?['userDateList'] as List).last.toDate();

      customTime ??= DateTime.now().difference(model).inSeconds;

      await _firestore.collection(AppConstants.usersCollection).doc(userId).update({
        "userTimeList": FieldValue.arrayUnion([customTime]),
      });

      await _firestore.collection(AppConstants.usersCollection).doc(userId).set({
        "userStatus": AppConstants.userStatusOnline,
      }, SetOptions(merge: true));
    } else {
      throw Failure(ResponseCode.NOT_FOUND, 'User not found');
    }
  }

  // Log user's login time
  Future<void> logLoginTime(String? userId) {
    return _firestore.collection(AppConstants.usersCollection).doc(userId).update({
      "logInDateList": FieldValue.arrayUnion([Timestamp.now().toDate()]),
      "userStatus": AppConstants.userStatusOnline,
    });
  }

  // Log user's logout time
  Future<void> logLogoutTime(String? userId) {
    return _firestore.collection(AppConstants.usersCollection).doc(userId).update({
      "logOutDateList": FieldValue.arrayUnion([Timestamp.now().toDate()]),
      "userStatus": AppConstants.userStatusOnline,
    });
  }
}
