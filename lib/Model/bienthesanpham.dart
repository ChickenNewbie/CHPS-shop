class BienTheSanPham {
  final int maCTSP;
  final int donGia;
  final int soLuongTon;
  final String tenSize;
  final String mauSac;

  BienTheSanPham({
    required this.maCTSP,
    required this.donGia,
    required this.soLuongTon,
    required this.tenSize,
    required this.mauSac,
  });

  factory BienTheSanPham.fromJson(Map<String, dynamic> json) {
    return BienTheSanPham(
      maCTSP: json['MaCTSP'],
      donGia: json['Dongia'],
      soLuongTon: json['SLT'],
      tenSize: json['TenSize'],
      mauSac: json['MauSac'],
    );
  }
}
