import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alert.dart';
import 'service_service.dart';

class AlertService {
  static const String _alertsKey = 'user_alerts';
  final ServiceService _serviceService = ServiceService();
  
  // Generate alerts for expiring services
  Future<List<Alert>> generateServiceAlerts(String userId) async {
    final services = await _serviceService.getExpiringServices();
    final alerts = <Alert>[];
    
    for (final service in services) {
      String alertType;
      String message;
      
      if (service.status == 'expired') {
        alertType = 'SERVICE_EXPIRED';
        message = '${service.title} a expiré le ${service.expirationDate.day}/${service.expirationDate.month}/${service.expirationDate.year}. Veuillez le renouveler.';
      } else if (service.status == 'expiring_soon') {
        alertType = 'SERVICE_EXPIRING';
        message = '${service.title} expire dans ${service.daysUntilExpiry} jours. Pensez à le renouveler.';
      } else {
        continue;
      }
      
      final alert = Alert(
        id: '${service.id}_alert_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        type: alertType,
        message: message,
        isRead: false,
        dateCreated: DateTime.now(),
        serviceId: service.id,
      );
      
      alerts.add(alert);
    }
    
    return alerts;
  }
  
  // Get all alerts (existing + service alerts)
  Future<List<Alert>> getAllAlerts(String userId) async {
    final existingAlerts = await _getStoredAlerts();
    final serviceAlerts = await generateServiceAlerts(userId);
    
    // Combine and deduplicate alerts
    final allAlerts = <String, Alert>{};
    
    // Add existing alerts
    for (final alert in existingAlerts) {
      allAlerts[alert.id] = alert;
    }
    
    // Add service alerts (will overwrite if same ID)
    for (final alert in serviceAlerts) {
      allAlerts[alert.id] = alert;
    }
    
    // Sort by date (newest first)
    final sortedAlerts = allAlerts.values.toList()
      ..sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    
    // Save updated alerts
    await _saveAlerts(sortedAlerts);
    
    return sortedAlerts;
  }
  
  // Get stored alerts from SharedPreferences
  Future<List<Alert>> _getStoredAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = prefs.getString(_alertsKey);
    
    if (alertsJson == null) {
      return [];
    }
    
    final List<dynamic> alertsList = jsonDecode(alertsJson);
    return alertsList.map((json) => Alert.fromJson(json)).toList();
  }
  
  // Save alerts to SharedPreferences
  Future<void> _saveAlerts(List<Alert> alerts) async {
    final prefs = await SharedPreferences.getInstance();
    final alertsJson = alerts.map((a) => a.toJson()).toList();
    await prefs.setString(_alertsKey, jsonEncode(alertsJson));
  }
  
  // Mark alert as read
  Future<void> markAlertAsRead(String alertId) async {
    final alerts = await _getStoredAlerts();
    final updatedAlerts = alerts.map((alert) {
      if (alert.id == alertId) {
        return Alert(
          id: alert.id,
          userId: alert.userId,
          type: alert.type,
          message: alert.message,
          isRead: true,
          dateCreated: alert.dateCreated,
          insuranceId: alert.insuranceId,
          insurance: alert.insurance,
          serviceId: alert.serviceId,
        );
      }
      return alert;
    }).toList();
    
    await _saveAlerts(updatedAlerts);
  }
  
  // Add a custom alert
  Future<void> addAlert(Alert alert) async {
    final alerts = await _getStoredAlerts();
    alerts.add(alert);
    await _saveAlerts(alerts);
  }
}
