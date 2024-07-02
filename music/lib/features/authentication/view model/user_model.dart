class UserModel {
  late String token;
  late User user;

  UserModel({required this.token, required this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    user = User.fromJson(json["user"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["token"] = token;
    data["user"] = user.toJson();
    return data;
  }
}

class User {
  late String name;
  late String email;
  late String profileUrl;

  User({required this.name, required this.email, required this.profileUrl});

  User.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    profileUrl = json["profile_url"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["name"] = name;
    data["email"] = email;
    data["profile_url"] = profileUrl;
    return data;
  }
}
