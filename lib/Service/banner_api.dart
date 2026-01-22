import 'dart:convert';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/banner.dart';
import 'package:http/http.dart' as http;

class BannerApi {
  static Future<List<BannerModel>> getAllBanner()async{
    final uri = '${ContantURL.baseUrl}/banner';
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
        final List<dynamic> banners = data['data'];
        return banners.map((b) => BannerModel.fromJson(b as Map<String, dynamic>)).toList();
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }
}