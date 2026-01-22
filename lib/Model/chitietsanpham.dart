import 'package:shopgiaydep_flutter/Model/bienthesanpham.dart';
import 'package:shopgiaydep_flutter/Model/mausac.dart';

class ChiTietSanPham{
  final int maSP;
  final String tenSP;
  final String moTa;
  final int status;
  final int maLoai;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double diemDanhGia;
  final int tongSoDanhGia;
  final int luotBan;
  final List<MauSac> images;
  final List<String> sizes;
  final List<String> mauSac;
  final List<BienTheSanPham> listBienThe;

  ChiTietSanPham({
    required this.maSP,
    required this.tenSP,
    required this.moTa,
    required this.status,
    required this.maLoai,
    required this.createdAt,
    required this.updatedAt,
    required this.diemDanhGia,
    required this.tongSoDanhGia,
    required this.luotBan,
    required this.images,
    required this.sizes,
    required this.mauSac,
    required this.listBienThe,
  });

  factory ChiTietSanPham.fromJson(Map<String, dynamic> json){
    return ChiTietSanPham(
      maSP: json['MaSP'],
      tenSP: json['TenSP'],
      moTa: json['MoTa'],
      status: json['Status'],
      maLoai: json['MaLoai'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      diemDanhGia: double.parse(json['DiemDanhGia'].toString()),
      tongSoDanhGia: json['TongSoDanhGia'],
      luotBan: json['LuotBan'],
      images: (json['images']as List).map((img) => MauSac.fromJson(img)).toList(),
      sizes: List<String>.from(json['sizes']),
      mauSac: List<String>.from(json['colors']),
      listBienThe: (json['variants'] as List)
      .map((v) => BienTheSanPham.fromJson(v)).toList()
    );
  }
}