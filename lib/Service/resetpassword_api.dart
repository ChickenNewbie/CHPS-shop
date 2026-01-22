import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
class AuthService {
  Future<void> sendOtp(String email) async {
    final url = Uri.parse('${ContantURL.baseUrl}/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      print("STATUS:${response.statusCode}");
      print("BODY:${response.body}");
      if (response.body.isEmpty) {
  throw Exception("Server không phản hồi");
}

dynamic data;
try {
  data = jsonDecode(response.body);
} catch (e) {
  throw Exception("Dữ liệu trả về không hợp lệ");
}

      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? "Lỗi gửi OTP");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
  Future<String> verifyOtp(String email, String otp) async {
    final url = Uri.parse('${ContantURL.baseUrl}/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (response.body.isEmpty) {
  throw Exception("Server không phản hồi");
}

dynamic data;
try {
  data = jsonDecode(response.body);
} catch (e) {
  throw Exception("Dữ liệu trả về không hợp lệ");
}
      if (response.statusCode == 200) {
        return data['token'];
      } else {
        throw Exception(data['message'] ?? "Xác thực thất bại");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
  Future<void> resetPassword(String token, String newPassword) async {
    final url = Uri.parse('${ContantURL.baseUrl}/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
        body: jsonEncode({'password': newPassword}),
      );
      if (response.body.isEmpty) {
  throw Exception("Server không phản hồi");
}

dynamic data;
try {
  data = jsonDecode(response.body);
} catch (e) {
  throw Exception("Dữ liệu trả về không hợp lệ");
}
      if (response.statusCode != 200) {
        throw Exception(data['message'] ?? "Đổi mật khẩu thất bại");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}