import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import './auth_service.dart';
import '../models/alert.dart';
import '../models/user_insurance.dart';

class DashboardService {
  final String _baseUrl = 'http://192.168.1.154:3000/api/dashboard'; // TODO: Remplacer par l'URL de votre backend
  final AuthService _authService;

  DashboardService(this._authService);

  Future<User?> fetchUserData() async {
    final token = await _authService.getToken();
    if (token == null) {
      // TODO: Implémenter un système de logging approprié
      return null;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      // TODO: Implémenter un système de logging approprié
      return null;
    }
  }

  Future<List<Alert>> fetchAlerts() async {
    final token = await _authService.getToken();
    if (token == null) {
      // TODO: Implémenter un système de logging approprié
      return [];
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/alerts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> alertsJson = data['alerts'];
      return alertsJson.map((json) => Alert.fromJson(json)).toList();
    } else {
      // TODO: Implémenter un système de logging approprié
      return [];
    }
  }

  Future<List<UserInsurance>> fetchUserInsurances() async {
    final token = await _authService.getToken();
    if (token == null) {
      // TODO: Implémenter un système de logging approprié
      return [];
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/insurances'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> insurancesJson = data['insurances'];
      return insurancesJson.map((json) => UserInsurance.fromJson(json)).toList();
    } else {
      // TODO: Implémenter un système de logging approprié
      return [];
    }
  }
}
