class CustomerModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? address;
  final String? otp;
  final String? otpExpiresAt;
  final DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    this.otp,
    this.otpExpiresAt,
    required this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      otp: json['otp'],
      otpExpiresAt: json['otpExpiresAt'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "otp": otp,
      "otpExpiresAt": otpExpiresAt,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}