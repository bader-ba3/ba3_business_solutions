import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/generate_id.dart';
import '../../model/seller/task_model.dart';

class TargetFireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _tasksCollection => _firestore.collection(AppConstants.tasksCollection);

  Stream<QuerySnapshot> getAllTargetsStream() {
    return _tasksCollection.snapshots();
  }

  Future<void> addTask(TaskModel taskModel) async {
    taskModel.taskId = generateId(RecordType.task);
    await _tasksCollection.doc(taskModel.taskId).set(taskModel.toJson());
  }

  Future<void> updateTask(TaskModel taskModel) async {
    await _tasksCollection.doc(taskModel.taskId).update(taskModel.toJson());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}
