import 'dart:convert';
import 'package:http/http.dart' as http;
import './auth_service.dart';

class WithdrawalService {
  final String _baseUrl = 'http://192.168.1.154:3000/api/retrait'; // TODO: Remplacer par l'URL de votre backend
  final AuthService _authService;

  WithdrawalService(this._authService);

  Future<Map<String, dynamic>> makeWithdrawal({
    required String phone,
    required String password,
    required String type,
    required double amount,
  }) async {
    final token = await _authService.getToken();
    if (token == null) {
      return {'success': false, 'message': 'Utilisateur non authentifié.'};
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'phone': phone,
        'password': password,
        'type': type,
        'amount': amount,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message'], 'tx_reference': data['tx_reference']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Erreur de retrait inconnue.'};
    }
  }
}
