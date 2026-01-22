import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/giohang.dart';

class CartApi {
  static Future<GioHang?> getAllCart() async {
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/view-cart';
    final url = Uri.parse(uri);
    
    try {
      final token = pref.getString('token');
      if (token == null) return null;
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final  cartList = data['data'];
        if (cartList != null && cartList.isNotEmpty) {
          return GioHang.fromJson(cartList as Map<String, dynamic>);
        }
        return null;
      } else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Không thể kết nối API giỏ hàng: $e");
    }
  }

  static Future<bool> addToCarrt(int maCTSP, int soLuong) async {
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/add-cart';
    final url = Uri.parse(uri);
    try {
        final token = pref.getString('token');
        if (token == null) return false;
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'maCTSP': maCTSP,
            'soLuong': soLuong,
          })
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['success'] == true;
        } 
        return false;
      }catch (e) {
        debugPrint("Lỗi AddToCart: $e");
        return false;
      }
  }

  static Future<bool> updateItem(int maGH, int maCTSP, int soLuong) async {
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/update-item';
    final url = Uri.parse(uri);
    try {
        final token = pref.getString('token');
        if (token == null) return false;
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'maGH' : maGH,
            'maCTSP': maCTSP,
            'soLuong': soLuong,
          })
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['success'] == true;
        } 
        return false;
      }catch (e) {
        debugPrint("Lỗi updateItem: $e");
        return false;
      }
  }

  static Future<bool> removeItem(int maGH, int maCTSP) async {
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/delete-item';
    final url = Uri.parse(uri);
    try {
        final token = pref.getString('token');
        if (token == null) return false;
        final response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            'maGH' : maGH,
            'maCTSP': maCTSP,
          })
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['success'] == true;
        } 
        return false;
      }catch (e) {
        debugPrint("Lỗi removeItem: $e");
        return false;
      }
  }
}
