import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/danhgia.dart';

class DanhgiaApi {
  static Future<List<DanhGia>> getReviewsById(int id) async{
    final uri = '${ContantURL.baseUrl}/products/review/all/$id';
    final url = Uri.parse(uri);
    try{
      final response = await http.get(
        url,
        headers: {
          'Content-Type' : 'application/json'
        }
      );
      if(response.statusCode == 200){
        debugPrint('lấy đc sản phẩm');
        final data = jsonDecode(response.body);
        final List<dynamic> danhgia = data['data'];
        return danhgia.map((re) => DanhGia.fromJson(re)).toList();
      }else {
        debugPrint('Lỗi else');
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
        debugPrint('lỗi catch');
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<List<DanhGia>> getReviewsByIdLimit(int id) async{
    final uri = '${ContantURL.baseUrl}/products/review/limit/$id';
    final url = Uri.parse(uri);
    try{
      final response = await http.get(
        url,
        headers: {
          'Content-Type' : 'application/json'
        }
      );
      if(response.statusCode == 200){
        debugPrint('lấy đc sản phẩm');
        final data = jsonDecode(response.body);
        final List<dynamic> danhgia = data['data'];
        return danhgia.map((re) => DanhGia.fromJson(re)).toList();
      }else {
        debugPrint('Lỗi else');
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
        debugPrint('lỗi catch');
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<bool> addReview({
    required int maCTSP,
    required double soSao,
    required String noiDung,
    required int maCTHD,
    File? image, 
  }) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      if (token == null) return false;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ContantURL.baseUrl}/rating/add'),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['MaCTSP'] = maCTSP.toString();
      request.fields['MaCTHD'] = maCTHD.toString();
      request.fields['SoSao'] = soSao.toString();
      request.fields['NoiDung'] = noiDung;

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'HinhAnhDG', 
            image.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi đánh giá - in catch: $e');
      return false;
    }
  }

  // static Future<bool> addReview({
  //   required int maCTSP,
  //   required double soSao,
  //   required String noiDung,
  //   required int maCTHD,
  // }) async {
  //   try {
  //     final pref = await SharedPreferences.getInstance();
  //     final token = pref.getString('token');
  //     if (token == null) return false;

  //     final response = await http.post(
  //       Uri.parse('${ContantURL.baseUrl}/rating/add'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'MaCTSP': maCTSP,
  //         'MaCTHD': maCTHD,
  //         'SoSao': soSao,
  //         'NoiDung': noiDung,
  //         'HinhAnhDG': ''
  //       }),
  //     );

  //     return response.statusCode == 200;
  //   } catch (e) {
  //     debugPrint('Lỗi đánh giá - in cath');
  //     return false;
  //   }
  // }
}