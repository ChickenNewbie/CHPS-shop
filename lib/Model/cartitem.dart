class CartItem {
  final int maCTGH;
  final int maGH;
  final int maCTSP;
  int soLuong;
  final int maSP;
  final String tenSP;
  final String tenSize;
  final String mauSac;
  final double donGia;
  final String hinhAnh;
  bool isSelected;

  CartItem({
    required this.maCTGH,
    required this.maGH,
    required this.maCTSP,
    required this.soLuong,
    required this.maSP,
    required this.tenSP,
    required this.tenSize,
    required this.mauSac,
    required this.donGia,
    required this.hinhAnh,
    this.isSelected = true
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      maCTGH: json['MaCTGH'],
      maGH: json['MaGH'],
      maCTSP: json['MaCTSP'],
      soLuong: json['SoLuong'],
      maSP : json['MaSp'],
      tenSP: json['TenSP'] ?? '',
      tenSize: json['TenSize'] ?? '',
      mauSac: json['MauSac'] ?? '',
      donGia: double.parse(json['Dongia'].toString()),
      hinhAnh: json['HinhAnh'] ?? '',
    );
  }
  Map<String, dynamic> toJsonForOrder() {
    return {
      "maCTSP": maCTSP,
      "soLuong": soLuong,
      "donGia": donGia,
    };
  }
}