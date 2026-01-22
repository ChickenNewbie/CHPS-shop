import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/user.dart';

class LoginApi {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );


  static Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = '${ContantURL.baseUrl}/login';
      final url = Uri.parse(uri);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await _saveUserData(data);
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Lỗi khi đăng nhập: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null;
      }

      final String email = googleUser.email;
      final String username = googleUser.displayName ?? email.split('@')[0];
      final String? photoUrl = googleUser.photoUrl;
      final uri = '${ContantURL.baseUrl}/login-social';
      
      final url = Uri.parse(uri);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'avatar': photoUrl,
          'provider': 'google',
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await _saveUserData(data);
          return data;
        }
      }
      return null;
    } catch (e) {
      debugPrint("---- [ERROR] LỖI NGHIÊM TRỌNG TRONG API: $e ----");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        
        final String email = userData['email'] ?? '';
        final String username = userData['name'] ?? email.split('@')[0];

        if (email.isEmpty) {
          throw Exception('Email không được cung cấp từ Facebook');
        }
        final uri = '${ContantURL.baseUrl}/login-social';
        final url = Uri.parse(uri);
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'username': username,
            'provider': 'facebook',
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            await _saveUserData(data);
            return data;
          }
        }
      } else if (result.status == LoginStatus.cancelled) {
        debugPrint('Facebook login cancelled');
        return null;
      }
      
      return null;
    } catch (e) {
      debugPrint('Lỗi đăng nhập Facebook: $e');
      return null;
    }
  }


  static Future<void> _saveUserData(Map<String, dynamic> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      if (data['user'] != null) {
        await prefs.setString('user_data', jsonEncode(data['user']));
      }
    } catch (e) {
      debugPrint('Lỗi lưu SharedPreferences: $e');
    }
  }

  static Future<bool> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final uri = '${ContantURL.baseUrl}/logout';
        await http.post(
          Uri.parse(uri),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
      await prefs.remove('token');
      await prefs.remove('user_data'); 
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      return true;
    } catch (e) {
      debugPrint('Lỗi khi logout: $e');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); 
      return false;
    }
  }

  static Future<User?> getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return null;

      final uri = '${ContantURL.baseUrl}/api/profile';
      final url = Uri.parse(uri);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return User.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Lỗi lấy profile: $e');
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      return null;
    }
  }

  static Future<User?> getUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataRaw = prefs.getString('user_data');

      if (userDataRaw != null) {
        Map<String, dynamic> userMap = jsonDecode(userDataRaw);
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      debugPrint('Lỗi lấy UserInfo: $e');
      return null;
    }
  }
  static Future<bool> isAdmin() async {
    final user = await getUserInfo();
    return user?.laAdmin == 1; 
  }

  static Future<Map<String, dynamic>?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final uri = '${ContantURL.baseUrl}/register'; 
      final url = Uri.parse(uri);
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username, 
          'email': email,
          'password': password,
        }),
      );
      final data = jsonDecode(response.body);
      return data; 
    } catch (e) {
      debugPrint('Lỗi khi đăng ký: $e');
      return {
        'success': false, 
        'message': 'Lỗi kết nối đến máy chủ'
      };
    }
  }
}


