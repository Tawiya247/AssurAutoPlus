import 'package:assurauto_app/models/insurance_type.dart';
import 'package:assurauto_app/models/vehicle.dart';

class Insurance {
  final String id;
  final String userId;
  final String insuranceTypeId;
  final String vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final double premiumAmount;
  final bool isActive;
  final Vehicle? vehicle;
  final InsuranceType? insuranceType;

  Insurance({
    required this.id,
    required this.userId,
    required this.insuranceTypeId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.premiumAmount,
    required this.isActive,
    this.vehicle,
    this.insuranceType,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      id: json['id'],
      userId: json['userId'],
      insuranceTypeId: json['insuranceTypeId'],
      vehicleId: json['vehicleId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      premiumAmount: (json['premiumAmount'] as num).toDouble(),
      isActive: json['isActive'],
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      insuranceType: json['insuranceType'] != null ? InsuranceType.fromJson(json['insuranceType']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'insuranceTypeId': insuranceTypeId,
      'vehicleId': vehicleId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'premiumAmount': premiumAmount,
      'isActive': isActive,
      'vehicle': vehicle?.toJson(),
      'insuranceType': insuranceType?.toJson(),
    };
  }
}
