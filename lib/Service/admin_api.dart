import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import '../Model/admin.dart'; 

class AdminApi {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Order>> getOrders({String? status}) async {
    try {
      final token = await _getToken();
      if (token == null) {
        debugPrint("Lỗi: Token null (Chưa đăng nhập)");
        return [];
      }
      String url = '${ContantURL.baseUrl}/admin/orders';
      if (status != null) url += '?status=$status';
      
      debugPrint("Đang gọi API: $url"); 

      final response = await http.get(
        Uri.parse(url), 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: ${response.body}");            

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['orders'] as List).map((json) => Order.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Lỗi Exception AdminApi: $e'); 
      return [];
    }
  }

  static Future<bool> updateStatus(String id, String status) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('${ContantURL.baseUrl}/admin/orders/$id/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );
      return response.statusCode == 200;
    } catch (e) { return false; }
  }
}