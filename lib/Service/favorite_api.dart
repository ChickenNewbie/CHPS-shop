import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';

class FavoriteApi {
  static Future<List<SanPham>> fetchSanPhamYeuThich() async{
    final uri = '${ContantURL.baseUrl}/favorites';
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
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final List<dynamic> products = data['data'];
        return products.map((p) => SanPham.fromJson(p as Map<String, dynamic>)).toList();
      }else if (response.statusCode == 401) {
        await pref.remove('token'); 
        await pref.remove('user_data');
        return []; 
      } 
      else {
        return []; 
      }
    }catch (e) {
      return [];
    }
  }


  static Future<bool> themXoaFavorite(int maSP) async {
    final uri = '${ContantURL.baseUrl}/favorites/add-delete'; 
    final pref = await SharedPreferences.getInstance();
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
        body: jsonEncode({'maSP': maSP}), 
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi toggleFavorite: $e");
      return false;
    }
  }
}