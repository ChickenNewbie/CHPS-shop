import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Model/user.dart';
import 'package:shopgiaydep_flutter/Provider/dathang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Service/login_api.dart';
import 'package:shopgiaydep_flutter/Service/profile_api.dart';

class AuthProvider extends ChangeNotifier{
  User? _user;
  String? _token;

  User? get user => _user;
  bool get isAuthenticated => _token != null;

  Future<void> loadSaveAuth()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    String? userJson = prefs.getString('user_data');
    debugPrint("Token load được: $_token");
    debugPrint("Dữ liệu User load được: $userJson");
    if(userJson != null){
      _user = User.fromJson(jsonDecode(userJson));
      debugPrint("Đã chuyển đổi User thành công: ${_user?.username}");
    }
    notifyListeners();
  }


  Future<void> saveAuth(String token, User userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = token;
    _user = userModel;
    await prefs.setString('token', token);
    await prefs.setString('user_data', jsonEncode(userModel.toJson())); 
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await LoginApi.logout();
    _user = null;
    _token = null;
    if(context.mounted){
      context.read<GioHangProvider>().resetCart();
      context.read<OrderProvider>().clearOrders();
    }
    notifyListeners();
  }

  Future<void> updateProfile({required User updatedInfo, String? password}) async {
    try {
      User newUser = await ProfileApi.updateProfile(
        user: updatedInfo, 
        password: password
      );
      _user = newUser;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(newUser.toJson()));
      debugPrint('Update profile is success');
      notifyListeners();
      
    } catch (e) {
      debugPrint('Lỗi catch');
      rethrow; 
    }
  }

  Future<void> uploadAvatar(File imageFile) async {
    try {
      String? newAvatarUrl = await ProfileApi.uploadAvatr(imageFile);
      if (newAvatarUrl != null && _user != null) {
        _user = User(
          username: _user!.username,
          email: _user!.email,
          diaChi: _user!.diaChi,
          soDienThoai: _user!.soDienThoai,
          avatar: newAvatarUrl, 
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(_user!.toJson()));
        notifyListeners();
        debugPrint("AuthProvider: Cập nhật ảnh đại diện thành công!");
      }
    } catch (e) {
      debugPrint("Lỗi tại AuthProvider (uploadAvatar): $e");
      rethrow; 
    }
  }
  

  Future<bool> changePassword({
    required String oldPassword, 
    required String newPassword
  }) async {
    try {
      bool success = await ProfileApi.changePassword(oldPassword, newPassword);
      if (success) {
        debugPrint("AuthProvider: Đổi mật khẩu thành công");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi tại AuthProvider (changePassword): $e");
      rethrow; 
    }
  }
    
  
}