import 'package:shopgiaydep_flutter/Model/orderItem.dart';

class Order {
  final int maHD;
  final int tongTienDH;
  final int status;
  final int phiShip;
  final int giaGiam;
  final String tenNguoiNhan;
  final String soDienThoai;
  final String diaChiGiaoHang;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.maHD,
    required this.tongTienDH,
    required this.status,
    required this.phiShip,
    required this.giaGiam,
    required this.tenNguoiNhan,
    required this.soDienThoai,
    required this.diaChiGiaoHang,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      maHD: json['MaHD'] ?? 0,
      tongTienDH: json['TongTienDH'] ?? 0,
      status: json['Status'] ?? 0,
      phiShip: json['PhiShip'] ?? 0,
      giaGiam: json['GiaGiam'] ?? 0,
      tenNguoiNhan: json['TenNguoiNhan'] ?? '',
      soDienThoai: json['SDTNguoiNhan'] ?? '' ,
      diaChiGiaoHang: json['DiaChiGiaHang'] ?? '',
      createdAt: DateTime.parse(json['CreatedAt'] ?? DateTime.now().toString()),
      items: (json['items'] as List?)
              ?.map((i) => OrderItem.fromJson(i))
              .toList() ?? [],
    );
  }
}