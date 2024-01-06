class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  RegisterRequest({
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

class RegisterResponse {
  final String? token;
  final String message;
  final int status;

  RegisterResponse({
    this.token,
    required this.message,
    required this.status,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        token: json["token"],
        message: json["message"],
        status: json["status"],
      );
}
