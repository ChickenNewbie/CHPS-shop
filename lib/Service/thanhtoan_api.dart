import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopgiaydep_flutter/Constant/urlConfig.dart';
import 'package:shopgiaydep_flutter/Model/cartitem.dart';

class ThanhToanApi{
  static Future<int?> ThanhToan({
    required List<CartItem> items,
    required String? maVoucher,
    required int maPVC,
    required int maPT,
    required String diaChi,
    required String sdt,
    required String tenNguoiNhan,
    required double giaShip,
    required double tongGiamGia,
    required double tongTienCuoi, 
  }) async {
    final pref = await SharedPreferences.getInstance();
    final uri = '${ContantURL.baseUrl}/checkout';
    final url = Uri.parse(uri);
    try {
        final token = pref.getString('token');
        if (token == null) return null;
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "items" : items.map((item) => item.toJsonForOrder()).toList(),
            "maVoucher": maVoucher,
            "maPVC": maPVC,
            "maPT": maPT,
            "diaChi": diaChi,
            "sdt": sdt,
            "tenNguoiNhan": tenNguoiNhan,
            "giaShip": giaShip,
            "tongGiamGia": tongGiamGia,
            "tongTienCuoi": tongTienCuoi,
          })
        );

        if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['maHD']; 
        }
      } else {
        debugPrint("Server trả về lỗi: ${response.statusCode}");
        return null;
      }
      }catch (e) {
      debugPrint("Lỗi kết nối API: $e");
      return null;
    }
  }
}