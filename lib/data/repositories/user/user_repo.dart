import 'package:ba3_business_solutions/data/model/user/role_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/network/error/error_handler.dart';
import '../../../core/network/error/failure.dart';
import '../../datasources/user/user_management_service.dart';
import '../../model/user/user_model.dart';

class UserManagementRepository {
  final UserManagementService _service;

  UserManagementRepository(this._service);

  Map<String, UserModel> allUsers = {};

  // Get all roles
  Future<Either<Failure, Map<String, RoleModel>>> getAllRoles() async {
    try {
      final allRoles = await _service.fetchAllRoles();
      return Right(allRoles);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Initialize or reset a user (for adding or editing)
  UserModel initializeUser({String? userId}) {
    if (userId != null && allUsers.containsKey(userId)) {
      return UserModel.fromJson(allUsers[userId]!.toJson());
    }
    return UserModel();
  }

  // Check user by PIN and update the user status
  Future<Either<Failure, UserModel?>> checkUserByPin(String userPin) async {
    try {
      final user = await _service.fetchUserByPin(userPin);
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Check card number and get the associated user
  Future<Either<Failure, UserModel?>> checkCard(String cardNumber) async {
    try {
      final card = await _service.fetchCardByNumber(cardNumber);
      if (card != null) {
        final user = await _service.fetchUserById(card.userId);
        return Right(user);
      }
      return Right(null);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Add or update a user
  Future<Either<Failure, Unit>> saveUser(UserModel user) async {
    try {
      await _service.saveUser(user);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Add or update a role
  Future<Either<Failure, Unit>> saveRole(RoleModel role) async {
    try {
      await _service.saveRole(role);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Log user's time report
  Future<Either<Failure, Unit>> logTimeReport(String userId, DateTime date) async {
    try {
      await _service.logTimeReport(userId: userId, date: date);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, Unit>> startTimeReport(String userId, {DateTime? customDate}) async {
    customDate ??= DateTime.now();
    try {
      await _service.startTimeReport(userId, customDate);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Send user's time report
  Future<Either<Failure, Unit>> sendTimeReport(String userId, {int? customTime}) async {
    try {
      await _service.sendTimeReport(userId, customTime);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Log user's login time
  Future<Either<Failure, Unit>> logLoginTime(String? userId) async {
    try {
      await _service.logLoginTime(userId);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  // Log user's logout time
  Future<Either<Failure, Unit>> logLogoutTime(String? userId) async {
    try {
      await _service.logLogoutTime(userId);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }
}
