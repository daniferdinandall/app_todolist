//DIGUNAKAN UNTUK INPUT FORM LOGIN
class RegisterInput {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  RegisterInput({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
      };
}

//DIGUNAKAN UNTUK RESPONSE LOGIN
class RegisterResponse {
  // final String? token;
  final String message;
  final bool status;

  RegisterResponse({
    // this.token,
    required this.message,
    required this.status,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        // token: json["token"],
        message: json["message"],
        status: json["status"],
      );
}
