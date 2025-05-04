import 'package:chatsetgo/model/user_model.dart';

class GroupModel {
  String? id;
  String? groupName;
  String? description;
  String? profileUrl;
  List<UserModel>? members;
  String? createdAt;
  String? createdBy;
  String? status;
  String? lastMessage;
  String? lastMessageTime;
  String? lastMessageBy;
  int? unReadCount;
  String? timeStamp;

  GroupModel({this.id, this.groupName, this.description, this.profileUrl, this.members, this.createdAt, this.createdBy, this.status, this.lastMessage, this.lastMessageTime, this.lastMessageBy, this.unReadCount, this.timeStamp,});

  GroupModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["groupName"] is String) {
      groupName = json["groupName"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["profileUrl"] is String) {
      profileUrl = json["profileUrl"];
    }

    if(json["members"] != null) {
      members = List<UserModel>.from(
        json["members"].map((memberJson) => UserModel.fromJson(memberJson))
      );
    } else {
      members = [];
    }

    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if(json["createdBy"] is String) {
      createdBy = json["createdBy"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if(json["lastMessageTime"] is String) {
      lastMessageTime = json["lastMessageTime"];
    }
    if(json["lastMessageBy"] is String) {
      lastMessageBy = json["lastMessageBy"];
    }
    if(json["unReadCount"] is int) {
      unReadCount = json["unReadCount"];
    }
    if(json["timeStamp"] is String) {
      timeStamp = json["timeStamp"];
    }
  }

  static List<GroupModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(GroupModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["groupName"] = groupName;
    _data["description"] = description;
    _data["profileUrl"] = profileUrl;
    if(members != null) {
      _data["members"] = members;
    }
    _data["createdAt"] = createdAt;
    _data["createdBy"] = createdBy;
    _data["status"] = status;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageTime"] = lastMessageTime;
    _data["lastMessageBy"] = lastMessageBy;
    _data["unReadCount"] = unReadCount;
    _data["timeStamp"] = timeStamp;
    return _data;
  }
}