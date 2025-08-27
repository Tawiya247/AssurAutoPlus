import 'dart:convert';
import 'package:http/http.dart' as http;
import './auth_service.dart';

class PaymentService {
  final String _baseUrl = 'http://192.168.1.154:3000/api/payment'; // TODO: Remplacer par l'URL de votre backend
  final AuthService _authService;

  PaymentService(this._authService);

  Future<Map<String, dynamic>> makePayment({
    required double amount,
    required String phoneNumber,
    required String network,
    required String identifier,
    String description = 'Paiement sur site',
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
        'amount': amount,
        'phoneNumber': phoneNumber,
        'network': network,
        'identifier': identifier,
        'description': description,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message'], 'tx_reference': data['tx_reference']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Erreur de paiement inconnue.'};
    }
  }
}
