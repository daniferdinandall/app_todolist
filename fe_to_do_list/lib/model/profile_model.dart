//DIGUNAKAN UNTUK FORM GET PROFILE
class ProfileModel {
  final String id;
  String name;
  String email;
  String phoneNumber;
  String base64url;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.base64url,
  });
  
  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phonenumber"],
        base64url: json["base64url"],
      );
}

//DIGUNAKAN UNTUK EDIT FORM PROFILE
class ProfileInput {
  final String name;
  final String phoneNumber;
  final String base64url;

  ProfileInput({
    required this.name,
    required this.phoneNumber,
    required this.base64url,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "phonenumber": phoneNumber,
        "base64url": base64url,
      };
}

//DIGUNAKAN UNTUK RESPONSE FORM EDIT PROFILE
class ProfileResponse {
  final String message;
  final bool status;

  ProfileResponse({
    required this.message,
    required this.status,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
        message: json["message"],
        status: json["status"],
      );
}
