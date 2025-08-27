import 'package:assurauto_app/models/insurance.dart';

class Alert {
  final String id;
  final String userId;
  final String type;
  final String message;
  final bool isRead;
  final DateTime dateCreated;
  final String? insuranceId;
  final Insurance? insurance;
  final String? serviceId;

  Alert({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.isRead,
    required this.dateCreated,
    this.insuranceId,
    this.insurance,
    this.serviceId,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      message: json['message'],
      isRead: json['isRead'] ?? false,
      dateCreated: DateTime.parse(json['dateCreated']),
      insuranceId: json['insuranceId'],
      insurance: json['insurance'] != null ? Insurance.fromJson(json['insurance']) : null,
      serviceId: json['serviceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'message': message,
      'isRead': isRead,
      'dateCreated': dateCreated.toIso8601String(),
      'insuranceId': insuranceId,
      'insurance': insurance?.toJson(),
      'serviceId': serviceId,
    };
  }
}
