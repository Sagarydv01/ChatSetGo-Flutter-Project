import 'package:chatsetgo/model/chat_model.dart';
import 'package:chatsetgo/model/user_model.dart';

class ChatRoomModel {
  String? id;
  UserModel? sender;
  UserModel? receiver;
  List<ChatModel>? messages;
  int? unReadMessNo;
  String? lastMessage;
  String? lastMessageTime;
  String? timeStamp;

  ChatRoomModel({this.id, this.sender, this.receiver, this.messages, this.unReadMessNo, this.lastMessage, this.lastMessageTime, this.timeStamp});

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["sender"] is Map) {
      sender = json["sender"] == null ? null : UserModel.fromJson(json["sender"]);
    }
    if(json["receiver"] is Map) {
      receiver = json["receiver"] == null ? null : UserModel.fromJson(json["receiver"]);
    }
    if(json["messages"] is List) {
      messages = json["messages"] ?? [];
    }
    if(json["unReadMessNo"] is int) {
      unReadMessNo = json["unReadMessNo"];
    }
    if(json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if(json["lastMessageTime"] is String) {
      lastMessageTime = json["lastMessageTime"];
    }
    if(json["timeStamp"] is String) {
      timeStamp = json["timeStamp"];
    }
  }

  static List<ChatRoomModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ChatRoomModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if(sender != null) {
      _data["sender"] = sender?.toJson();
    }
    if(receiver != null) {
      _data["receiver"] = receiver?.toJson();
    }
    if(messages != null) {
      _data["messages"] = messages;
    }
    _data["unReadMessNo"] = unReadMessNo;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageTime"] = lastMessageTime;
    _data["timeStamp"] = timeStamp;
    return _data;
  }
}
