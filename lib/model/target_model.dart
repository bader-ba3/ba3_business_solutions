class TaskModel {
  String? taskId;
  String? taskProductId;
  int? taskQuantity;

  TaskModel({this.taskId , this.taskProductId ,  this.taskQuantity});

  TaskModel.fromJson(json){
    taskId = json['taskId'];
    taskProductId = json['taskProductId'];
    taskQuantity = json['taskQuantity'];
  }

  toJson(){
    return {
      "taskId":taskId,
      "taskProductId":taskProductId,
      "taskQuantity":taskQuantity,
    };
  }

}