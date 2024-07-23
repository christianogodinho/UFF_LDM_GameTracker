class LoginUser {
    final String email;
    final String password;

    LoginUser({
        required this.email,
        required this.password,
    });

    factory LoginUser.fromMap(Map<String, dynamic> json) => LoginUser(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
    };
}
