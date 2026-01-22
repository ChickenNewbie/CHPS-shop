import 'dart:convert';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/chitietsanpham.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:http/http.dart' as http;
class ProductApi {
  static Future<List<SanPham>> fetchSanPham() async{
    final uri = '${ContantURL.baseUrl}/products';
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
        return products.map((p) => SanPham.fromJson(p as Map<String, dynamic>)).toList();
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<List<SanPham>> fetchBestSanPham() async{
    final uri = '${ContantURL.baseUrl}/best-products';
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
        return products.map((p) => SanPham.fromJson(p as Map<String, dynamic>)).toList();
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<ChiTietSanPham> getProductDetail(int id) async{
    final uri = '${ContantURL.baseUrl}/products/$id';
    final url = Uri.parse(uri);
    try{
      final response = await http.get(
        url,
        headers: {
          'Content-Type' : 'application/json'
        }
      );
      if(response.statusCode == 200){
        print('lấy đc sản phẩm');
        final data = jsonDecode(response.body);
        final product = data['data'];
        return ChiTietSanPham.fromJson(product);
      }else {
        print('Lỗi else');
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
        print('lỗi catch');
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<List<SanPham>> fetchDanhMucSanPham(int id) async{
    final uri = '${ContantURL.baseUrl}/products/category/$id';
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
        return products.map((p) => SanPham.fromJson(p as Map<String, dynamic>)).toList();
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }
}