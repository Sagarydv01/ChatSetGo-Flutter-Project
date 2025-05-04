class ChatModel {
  String? id;
  String? message;
  String? timeStamp;
  String? readStatus;
  String? senderId;
  String? senderName;
  String? receiverId;
  String? receiverName;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentUrl;
  List<String>? reactions;
  List<dynamic>? replies;

  ChatModel({this.id, this.message, this.timeStamp, this.readStatus, this.senderId, this.senderName, this.receiverId, this.receiverName, this.imageUrl, this.videoUrl, this.audioUrl, this.documentUrl, this.reactions, this.replies});

  ChatModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["timeStamp"] is String) {
      timeStamp = json["timeStamp"];
    }
    if(json["readStatus"] is String) {
      readStatus = json["readStatus"];
    }
    if(json["senderId"] is String) {
      senderId = json["senderId"];
    }
    if(json["senderName"] is String) {
      senderName = json["senderName"];
    }
    if(json["receiverId"] is String) {
      receiverId = json["receiverId"];
    }
    if(json["receiverName"] is String) {
      receiverName = json["receiverName"];
    }
    if(json["imageUrl"] is String) {
      imageUrl = json["imageUrl"];
    }
    if(json["videoUrl"] is String) {
      videoUrl = json["videoUrl"];
    }
    if(json["audioUrl"] is String) {
      audioUrl = json["audioUrl"];
    }
    if(json["documentUrl"] is String) {
      documentUrl = json["documentUrl"];
    }
    if(json["reactions"] is List) {
      reactions = json["reactions"] == null ? null : List<String>.from(json["reactions"]);
    }
    if(json["replies"] is List) {
      replies = json["replies"] ?? [];
    }
  }

  static List<ChatModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ChatModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["message"] = message;
    _data["timeStamp"] = timeStamp;
    _data["readStatus"] = readStatus;
    _data["senderId"] = senderId;
    _data["senderName"] = senderName;
    _data["receiverId"] = receiverId;
    _data["receiverName"] = receiverName;
    _data["imageUrl"] = imageUrl;
    _data["videoUrl"] = videoUrl;
    _data["audioUrl"] = audioUrl;
    _data["documentUrl"] = documentUrl;
    if(reactions != null) {
      _data["reactions"] = reactions;
    }
    if(replies != null) {
      _data["replies"] = replies;
    }
    return _data;
  }
}