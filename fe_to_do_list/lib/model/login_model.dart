//DIGUNAKAN UNTUK FORM LOGIN
class LoginInput {
  final String email;
  final String password;

  LoginInput({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

//DIGUNAKAN UNTUK RESPONSE
class LoginResponse {
  final String? token;
  final String message;
  final bool status;

  LoginResponse({
    this.token,
    required this.message,
    required this.status,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"]?? "",
        message: json["message"],
        status: json["status"],
      );
}
