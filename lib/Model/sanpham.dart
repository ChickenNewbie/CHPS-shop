  import 'package:flutter/material.dart';
  import 'package:shopgiaydep_flutter/Model/danhmuc.dart';

  class SanPham {
    final int maSP;
    final String tenSP;
    final int maLoai;
    final double giaBan; 
    final double diemDanhGia;
    final int luotBan;
    final String anhDaiDien;
    bool isYeuThich;
    final DanhMuc? danhMuc;

    SanPham({
      required this.maSP,
      required this.tenSP,
      required this.maLoai,
      required this.giaBan,
      required this.diemDanhGia,
      required this.luotBan,
      required this.anhDaiDien,
      required this.isYeuThich,
      this.danhMuc,
    });

    factory SanPham.fromJson(Map<String, dynamic> json) {
    try {
      return SanPham(
        maSP: json["MaSP"] as int,
        tenSP: json["TenSP"] as String,
        maLoai: json["MaLoai"] as int,
        giaBan: (json["GiaBan"] as num).toDouble(),
        diemDanhGia: (json["DiemDanhGia"] as num).toDouble(),
        luotBan: json["LuotBan"] as int,
        anhDaiDien: json["AnhDaiDien"] as String,
        isYeuThich: json["isYeuThich"] as bool,
        danhMuc: json["danh_muc"] != null 
            ? DanhMuc.fromJson(json["danh_muc"] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      debugPrint("Lỗi chi tiết: $e");
      throw FormatException('Lỗi định dạng JSON sản phẩm: $e');
    }
  }
  }