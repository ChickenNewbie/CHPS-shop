import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/order.dart';

class OrderApi {
  static Future<List<Order>> getOrderByStatus(int id)async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/my-order?status=$id';
    final url = Uri.parse(uri);
    try{
      final String? token = pref.getString('token');
      if (token == null) {
        throw Exception("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final List listOrders = data['data'] ?? [];
        return listOrders.map((json) => Order.fromJson(json)).toList();
        
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<bool> cancelOrder(int maHD) async {
    final pref = await SharedPreferences.getInstance();
    final url = Uri.parse('${ContantURL.baseUrl}/cancel-order');
    try {
      final String? token = pref.getString('token');
      if (token == null) return false;
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'maHD': maHD}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi khi gọi API hủy đơn: $e");
      return false;
    }
  }
}