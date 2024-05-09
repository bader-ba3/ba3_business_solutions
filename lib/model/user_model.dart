class UserModel {
  String? userId, userName, userPin, userRole,userSellerId;
  List? userFaceId=[];

  UserModel({
    this.userId,
    this.userName,
    this.userPin,
    this.userRole,
    this.userSellerId,
    this.userFaceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userSellerId': userSellerId,
      'userName': userName,
      'userPin': userPin,
      'userRole': userRole,
      "userFaceId":userFaceId
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userSellerId: json['userSellerId'],
      userName: json['userName'],
      userPin: json['userPin'],
      userRole: json['userRole'],
      userFaceId: json['userFaceId'],
    );
  }
}
