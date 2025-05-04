class UserModel {
  // Fields to represent user data
  String? id;
  String? name;
  String? email;
  String? mobileNumber;
  String? about;
  String? profilePic;
  String? createdAt;
  String? lastOnlineStatus;
  String? status;
  String? role;

  // Constructor to initialize the UserModel
  UserModel({
    this.id,
    this.name,
    this.email,
    this.mobileNumber,
    this.about,
    this.profilePic,
    this.createdAt,
    this.lastOnlineStatus,
    this.status,
    this.role,
  });

  // Named constructor to create a UserModel from a JSON map
  UserModel.fromJson(Map<String, dynamic> json) {
    // Check if each field in the JSON map is of the correct type (String)
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["mobileNumber"] is String) {
      mobileNumber = json["mobileNumber"];
    }
    if (json["about"] is String) {
      about = json["about"];
    }
    if (json["profilePic"] is String) {
      profilePic = json["profilePic"];
    }
    if (json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if (json["lastOnlineStatus"] is String) {
      lastOnlineStatus = json["lastOnlineStatus"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["role"] is String) {
      role = json["role"];
    }
  }

  // Static method to convert a list of JSON maps into a list of UserModel objects
  static List<UserModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserModel.fromJson).toList();
  }

  // Method to convert the UserModel instance to a JSON map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["mobileNumber"] = mobileNumber;
    _data["about"] = about;
    _data["profilePic"] = profilePic;
    _data["createdAt"] = createdAt;
    _data["lastOnlineStatus"] = lastOnlineStatus;
    _data["status"] = status;
    _data["role"] = role;
    return _data;
  }
}
