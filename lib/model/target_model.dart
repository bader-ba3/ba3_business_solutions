class TaskModel {
  String? taskId;
  String? taskProductId;
  String? taskType;
  String? taskInventory;
  int? taskQuantity;
  List<String>? taskUserListId;

  TaskModel({this.taskId , this.taskProductId ,  this.taskQuantity,this.taskUserListId,this.taskType,this.taskInventory});

  TaskModel.fromJson(json){
    taskId = json['taskId'];
    taskProductId = json['taskProductId'];
    taskQuantity = json['taskQuantity'];
    taskType = json['taskType'];
    taskInventory = json['taskInventory'];
    taskUserListId = json['taskUserListId'];
  }

  toJson(){
    return {
      "taskId":taskId,
      "taskProductId":taskProductId,
      "taskQuantity":taskQuantity,
      "taskUserListId":taskUserListId,
      "taskInventory":taskInventory,
      "taskType":taskType,
    };
  }

}