import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  RegisterResponse({
    required this.success,
    required this.msg,
    this.confirmUrl,
  });

  bool success;
  String msg;
  String? confirmUrl;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
          success: json["success"],
          msg: json["msg"],
          confirmUrl: json['confirm_url'] ?? '');

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        'confirm_url': confirmUrl,
      };
}
