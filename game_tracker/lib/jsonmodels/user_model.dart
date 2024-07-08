class Users {
    final int? id;
    final String name;
    final String email;
    final String password;

    Users({
        this.id,
        required this.name,
        required this.email,
        required this.password,
    });

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
    };
}
