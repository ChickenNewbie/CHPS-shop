import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/diachi.dart';

class AddressApi{
  static Future<List<DiaChi>> getAllAddress()async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/get-address';
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
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final List<dynamic> address = data['data'];
        return address.map((add) => DiaChi.fromJson(add as Map<String, dynamic>)).toList();
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<DiaChi?> addAddress(Map<String, dynamic> data)async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/add-address';
    final url = Uri.parse(uri);
    try{
      final String? token = pref.getString('token');
      if (token == null) {
        throw Exception("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
      }
      final response = await http.post(
        url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: jsonEncode(data)
      );
      if(response.statusCode == 200){
        final res = jsonDecode(response.body);
        return DiaChi.fromJson(res['data']);
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<Map<String, dynamic>> getPriceByAddress(String diachi)async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/ship';
    final url = Uri.parse(uri);
    try{
      final String? token = pref.getString('token');
      if (token == null) {
        throw Exception("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
      }
      final response = await http.post(
        url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: jsonEncode({
          "diachi" : diachi
        })
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return {
          "maPVC": data['maPVC'],
          "phivanchuyen": data['phivanchuyen'].toDouble(),
        };
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }


  static Future<DiaChi?> updateAddress(int id, Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/update-address/$id'; 
    final url = Uri.parse(uri);
    try {
      final String? token = pref.getString('token');
      if (token == null) {
        throw Exception("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        return DiaChi.fromJson(res['data']);
      } else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<bool> deleteAddress(int id) async {
    final pref = await SharedPreferences.getInstance();

    final uri = '${ContantURL.baseUrl}/delete-address/$id';
    final url = Uri.parse(uri);

    try {
      final String? token = pref.getString('token');
      if (token == null) {
        throw Exception("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
      }

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return true; 
      } else {
        return false; 
      }
    } catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }
}