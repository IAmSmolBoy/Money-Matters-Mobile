class User {

  String id,
  username,
  email,
  password;

  User(this.id, this.username, this.email, this.password);

  static User fromJSON(Map<String, dynamic> json) => User(
    json["id"]!,
    json["username"]!,
    json["email"]!,
    json["password"]!,
  );

  Map<String, String> toJSON() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
  };

}