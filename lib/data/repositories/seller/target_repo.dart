import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../core/network/error/error_handler.dart';
import '../../../core/network/error/failure.dart';
import '../../datasources/seller/target_firestore_service.dart';
import '../../model/seller/task_model.dart';

class TargetRepository {
  final TargetFireStoreService _targetService;

  TargetRepository(this._targetService);

  Stream<Map<String, TaskModel>> getAllTargets() {
    return _targetService.getAllTargetsStream().map((snapshot) {
      return Map<String, TaskModel>.fromEntries(
        snapshot.docs.map(
          (doc) => MapEntry(doc.id, TaskModel.fromJson(doc.data() as Map<String, dynamic>)),
        ),
      );
    });
  }

  Future<Either<Failure, Unit>> addTask(TaskModel taskModel) async {
    try {
      await _targetService.addTask(taskModel);
      return const Right(unit);
    } catch (e) {
      log('error from addTask: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, Unit>> updateTask(TaskModel taskModel) async {
    try {
      await _targetService.updateTask(taskModel);
      return const Right(unit);
    } catch (e) {
      log('error from updateTask: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  Future<Either<Failure, Unit>> deleteTask(String taskId) async {
    try {
      await _targetService.deleteTask(taskId);
      return const Right(unit);
    } catch (e) {
      log('error from deleteTask: $e');
      return Left(ErrorHandler(e).failure);
    }
  }
}
