import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/user.dart';

class ProfileApi {
  static Future<User> updateProfile({required User user, String? password})async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/update-profile';
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
          ...user.toJson(),
          if(password != null && password.isNotEmpty) 'password' : password
        })
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      }else {
        throw Exception("Lỗi server: ${response.statusCode}");
      }
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }

  static Future<String?> uploadAvatr(File imageFile)async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/upload-image-avatar';
    final url = Uri.parse(uri);
    try{
     final String? token = pref.getString('token');
      if (token == null) {
        throw Exception("Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.");
      }

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath(
        'avatar', 
        imageFile.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['user']['avatar']; 
        }
      }
      throw Exception("Lỗi server: ${response.statusCode}");
    }catch (e) {
      throw Exception("Không thể upload ảnh: $e");
    }
  }

  static Future<bool> changePassword(String oldPass, String newPass)async{
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/changePassword';
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
          'oldPassword': oldPass,
          'newPassword': newPass,
        })
      );
      return response.statusCode == 200;
    }catch (e) {
      throw Exception("Không thể kết nối API: $e");
    }
  }
}