import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/service.dart';

class ServiceService {
  static const String _servicesKey = 'user_services';
  
  // Save a new service
  Future<void> saveService(Service service) async {
    final prefs = await SharedPreferences.getInstance();
    final services = await getUserServices();
    services.add(service);
    
    final servicesJson = services.map((s) => s.toJson()).toList();
    await prefs.setString(_servicesKey, jsonEncode(servicesJson));
  }
  
  // Get all user services
  Future<List<Service>> getUserServices() async {
    final prefs = await SharedPreferences.getInstance();
    final servicesJson = prefs.getString(_servicesKey);
    
    if (servicesJson == null) {
      return [];
    }
    
    final List<dynamic> servicesList = jsonDecode(servicesJson);
    return servicesList.map((json) => Service.fromJson(json)).toList();
  }
  
  // Update service status based on expiry dates
  Future<List<Service>> getUpdatedServices() async {
    final services = await getUserServices();
    final updatedServices = <Service>[];
    
    for (final service in services) {
      final daysUntilExpiry = Service.calculateDaysUntilExpiry(service.expirationDate);
      final status = Service.calculateStatus(daysUntilExpiry);
      
      final updatedService = Service(
        id: service.id,
        userId: service.userId,
        type: service.type,
        title: service.title,
        vehicleImmatriculation: service.vehicleImmatriculation,
        vehicleMarque: service.vehicleMarque,
        vehicleModele: service.vehicleModele,
        serviceDate: service.serviceDate,
        expirationDate: service.expirationDate,
        status: status,
        daysUntilExpiry: daysUntilExpiry,
        serviceDetails: service.serviceDetails,
      );
      
      updatedServices.add(updatedService);
    }
    
    // Save updated services back to storage
    final prefs = await SharedPreferences.getInstance();
    final servicesJson = updatedServices.map((s) => s.toJson()).toList();
    await prefs.setString(_servicesKey, jsonEncode(servicesJson));
    
    return updatedServices;
  }
  
  // Get services that are expiring soon or expired for alerts
  Future<List<Service>> getExpiringServices() async {
    final services = await getUpdatedServices();
    return services.where((service) => 
      service.status == 'expiring_soon' || service.status == 'expired'
    ).toList();
  }
  
  // Create a service from form data
  Service createServiceFromFormData({
    required String userId,
    required String type,
    required String nom,
    required String prenom,
    required String telephone,
    required String immatriculation,
    required String marque,
    required String modele,
    required DateTime serviceDate,
    Map<String, dynamic>? additionalDetails,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final expirationDate = Service.calculateExpirationDate(type, serviceDate);
    final daysUntilExpiry = Service.calculateDaysUntilExpiry(expirationDate);
    final status = Service.calculateStatus(daysUntilExpiry);
    
    String title;
    switch (type) {
      case 'tvm':
        title = 'TVM - $marque $modele';
        break;
      case 'assurance':
        title = 'Assurance - $marque $modele';
        break;
      case 'visite_technique':
        title = 'Visite Technique - $marque $modele';
        break;
      default:
        title = 'Service - $marque $modele';
    }
    
    final serviceDetails = {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      ...?additionalDetails,
    };
    
    return Service(
      id: id,
      userId: userId,
      type: type,
      title: title,
      vehicleImmatriculation: immatriculation,
      vehicleMarque: marque,
      vehicleModele: modele,
      serviceDate: serviceDate,
      expirationDate: expirationDate,
      status: status,
      daysUntilExpiry: daysUntilExpiry,
      serviceDetails: serviceDetails,
    );
  }
}
