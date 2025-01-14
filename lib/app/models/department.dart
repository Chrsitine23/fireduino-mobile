class FireDepartmentModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  FireDepartmentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory FireDepartmentModel.fromJson(Map<String, dynamic> json) {
    return FireDepartmentModel(
      id: json['a'],
      name: json['b'],
      phone: json['c'],
      address: json['d'],
      latitude: double.parse(json['e']),
      longitude: double.parse(json['f']),
      createdAt: DateTime.parse(json['g']),
    );
  }

  Map<String, dynamic> toJson() => {
    'a': id,
    'b': name,
    'c': phone,
    'd': address,
    'e': latitude,
    'f': longitude,
    'g': createdAt.toIso8601String(),
  };
}