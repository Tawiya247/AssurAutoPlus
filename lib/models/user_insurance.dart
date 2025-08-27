class UserInsurance {
  final String id;
  final String type;
  final String vehicleModel;
  final String vehicleYear;
  final DateTime expirationDate;
  final double estimatedCost;
  final String status;
  final int daysUntilExpiry;

  UserInsurance({
    required this.id,
    required this.type,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.expirationDate,
    required this.estimatedCost,
    required this.status,
    required this.daysUntilExpiry,
  });

  factory UserInsurance.fromJson(Map<String, dynamic> json) {
    return UserInsurance(
      id: json['id'],
      type: json['type'],
      vehicleModel: json['vehicleModel'],
      vehicleYear: json['vehicleYear'],
      expirationDate: DateTime.parse(json['expirationDate']),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
      status: json['status'],
      daysUntilExpiry: json['daysUntilExpiry'],
    );
  }
}
