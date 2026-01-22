import 'package:shopgiaydep_flutter/Model/cartitem.dart';
class GioHang {
  final int maGH;
  final List<CartItem> items;

  GioHang({required this.maGH, required this.items});

  factory GioHang.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    return GioHang(
      maGH: json['MaGH'],
      items: list.map((i) => CartItem.fromJson(i)).toList(),
    );
  }
}