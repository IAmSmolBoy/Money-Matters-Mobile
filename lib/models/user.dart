class User {

  String id,
  username,
  email,
  password;
  String? pfp;

  User(this.id, this.username, this.email, this.password, [this.pfp]);

  static User? fromJSON(Map<String, dynamic> json) {
    if (["id", "username", "email", "password"].any((field) => json[field] == null)) return null;
    return User(
      json["id"]!,
      json["username"]!,
      json["email"]!,
      json["password"]!,
      json["pfp"] ?? "",
    );
  }

  Map<String, String?> toJSON() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
    "pfp": pfp,
  };

}