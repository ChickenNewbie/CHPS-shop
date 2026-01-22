class OrderItem {
  final int maCTSP;
  final int soLuong;
  final int gia;
  final String tenSP;
  final int maSP;
  final String tenSize;
  final String mauSac;
  final String hinhAnh;
  final int maCTHD; 
  bool daDanhGia; 

  OrderItem({
    required this.maCTSP,
    required this.soLuong,
    required this.gia,
    required this.tenSP,
    required this.maSP,
    required this.tenSize,
    required this.mauSac,
    required this.hinhAnh,
    this.maCTHD = 0,
    this.daDanhGia = false,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      maCTSP: json['MaCTSP'] ?? 0,
      soLuong: json['SoLuong'] ?? 0,
      gia: json['Gia'] ?? 0,
      tenSP: json['TenSP'] ?? '',
      maSP: json['MaSP'] ?? 0,
      tenSize: json['TenSize'] ?? '',
      mauSac: json['MauSac'] ?? '',
      hinhAnh: json['HinhAnh'] ?? '',
      maCTHD: json['MaCTHD'] ?? 0, 
      daDanhGia: (json['DaDanhGia'] == 1 || json['DaDanhGia'] == true),
    );
  }
}