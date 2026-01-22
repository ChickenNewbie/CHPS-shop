import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/phuongthucthanhtoan.dart';

class PhuongThucThanhToanApi{
  static Future<List<PhuongThucThanhToan>> getAllPayment()async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/payments';
    final url = Uri.parse(uri);
    try{
      final token = pref.getString('token');
      if (token == null) return [];
      final response = await http.get(
        url,
        headers: {
          'Content-Type' : 'application/json',
           'Authorization': 'Bearer $token'
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final List<dynamic> payments = data['data'];
        return payments.map((p) => PhuongThucThanhToan.fromJson(p as Map<String, dynamic>)).toList();
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }
}