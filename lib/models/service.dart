class Service {
  final String id;
  final String userId;
  final String type; // 'tvm', 'assurance', 'visite_technique'
  final String title;
  final String vehicleImmatriculation;
  final String vehicleMarque;
  final String vehicleModele;
  final DateTime serviceDate; // Date when service was completed
  final DateTime expirationDate; // When service expires and needs renewal
  final String status; // 'active', 'expiring_soon', 'expired'
  final int daysUntilExpiry;
  final Map<String, dynamic> serviceDetails; // Additional service-specific data

  Service({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.vehicleImmatriculation,
    required this.vehicleMarque,
    required this.vehicleModele,
    required this.serviceDate,
    required this.expirationDate,
    required this.status,
    required this.daysUntilExpiry,
    required this.serviceDetails,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      title: json['title'],
      vehicleImmatriculation: json['vehicleImmatriculation'],
      vehicleMarque: json['vehicleMarque'],
      vehicleModele: json['vehicleModele'],
      serviceDate: DateTime.parse(json['serviceDate']),
      expirationDate: DateTime.parse(json['expirationDate']),
      status: json['status'],
      daysUntilExpiry: json['daysUntilExpiry'],
      serviceDetails: Map<String, dynamic>.from(json['serviceDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'vehicleImmatriculation': vehicleImmatriculation,
      'vehicleMarque': vehicleMarque,
      'vehicleModele': vehicleModele,
      'serviceDate': serviceDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'status': status,
      'daysUntilExpiry': daysUntilExpiry,
      'serviceDetails': serviceDetails,
    };
  }

  // Calculate expiration date based on service type and completion date
  static DateTime calculateExpirationDate(String serviceType, DateTime serviceDate) {
    switch (serviceType) {
      case 'tvm':
        return serviceDate.add(const Duration(days: 365)); // TVM valid for 1 year
      case 'assurance':
        return serviceDate.add(const Duration(days: 365)); // Insurance valid for 1 year
      case 'visite_technique':
        return serviceDate.add(const Duration(days: 730)); // Technical visit valid for 2 years
      default:
        return serviceDate.add(const Duration(days: 365));
    }
  }

  // Calculate status based on days until expiry
  static String calculateStatus(int daysUntilExpiry) {
    if (daysUntilExpiry < 0) {
      return 'expired';
    } else if (daysUntilExpiry <= 30) {
      return 'expiring_soon';
    } else {
      return 'active';
    }
  }

  // Calculate days until expiry
  static int calculateDaysUntilExpiry(DateTime expirationDate) {
    final now = DateTime.now();
    return expirationDate.difference(now).inDays;
  }
}
