class StaffModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int branchId;
  final int roleId;
  final String roleName;
  final String branchName;

  StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.branchId,
    required this.roleId,
    required this.roleName,
    required this.branchName,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      branchId: json['branchId'] ?? 0,
      roleId: json['roleId'] ?? 0,
      roleName: json['role']?['name'] ?? "",
      branchName: json['branch']?['name'] ?? "",
    );
  }
}