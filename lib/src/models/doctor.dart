class Doctor {
  final int? id;
  final String name;
  final String specialization;
  final String phoneNumber;
  final String email;
  final String address;

  Doctor({
    this.id,
    required this.name,
    required this.specialization,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'],
        name: json['name'],
        specialization: json['specialization'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialization': specialization,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
      };
}
