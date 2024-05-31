class UserModel {
  String? userId, userName, userPin, userRole, userSellerId, userStatus;
  List? userFaceId = [];
  List<DateTime>? userDateList= [];
  List<int>? userTimeList= [];


  UserModel({
    this.userId,
    this.userName,
    this.userPin,
    this.userRole,
    this.userSellerId,
    this.userFaceId,
    this.userStatus,
    this.userTimeList,
    this.userDateList,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userSellerId': userSellerId,
      'userName': userName,
      'userPin': userPin,
      'userRole': userRole,
      "userFaceId": userFaceId,
      "userStatus": userStatus,
      "userTimeList": userTimeList,
      "userDateList": userDateList,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<DateTime> userDateList = [];
    List<int> userTimeList = [];
    if(json['userDateList'] != null) {
      for (var element in (json['userDateList'] as List<dynamic> )) {
        if(element.runtimeType == DateTime){
          userDateList.add(element);
        }else{
          userDateList.add(element.toDate());
        }
      }
    }

    if(json['userTimeList'] != null) {
      for (var element in (json['userTimeList'] as List<dynamic> )) {
        userTimeList.add(int.parse(element.toString()));
      }
    }
      return UserModel(
      userId: json['userId'],
      userSellerId: json['userSellerId'],
      userName: json['userName'],
      userPin: json['userPin'],
      userRole: json['userRole'],
      userFaceId: json['userFaceId'],
      userStatus: json['userStatus'],
        userTimeList: userTimeList,
        userDateList: userDateList,
    );
  }
}
