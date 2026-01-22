import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/giamgia.dart';

class GiamGiaApi {
  static Future<List<GiamGia>> getAllVouchers()async{
    final uri = '${ContantURL.baseUrl}/vouchers';
    final pref = await SharedPreferences.getInstance();
    final url = Uri.parse(uri);
    try{
      final token = pref.getString('token');
      if (token == null) return [];
      final response = await http.get(
        url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final List<dynamic> vouchers = data['data'];
        return vouchers.map((v) => GiamGia.fromJson(v as Map<String, dynamic>)).toList();
      }else {
        return [];
      }
    }catch (e) {
      return [];
    }
  }
}