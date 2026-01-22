import 'dart:convert';

import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/danhmuc.dart';
import 'package:http/http.dart' as http;
class CategoryAPI{
  static Future<List<DanhMuc>> fetchDanhMuc() async{
    final uri = '${ContantURL.baseUrl}/category';
    final url = Uri.parse(uri);
    try{
      final response = await http.get(
        url,
        headers: {
          'Content-Type' : 'application/json'
        }
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final List<dynamic> products = data['data'];
        return products.map((d) => DanhMuc.fromJson(d as Map<String, dynamic>)).toList();
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }
}