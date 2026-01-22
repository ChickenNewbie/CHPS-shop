class GiamGia {
  final String maVoucher;
  final String tenVoucher;
  final int giaTriGiam; 
  final double giamToiDa;
  final double donHangToiThieu;
  final int soLuongVoucher;
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final int status;

  GiamGia({
    required this.maVoucher,
    required this.tenVoucher,
    required this.giaTriGiam,
    required this.giamToiDa,
    required this.donHangToiThieu,
    required this.soLuongVoucher,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.status,
  });

  factory GiamGia.fromJson(Map<String, dynamic> json) {
    return GiamGia(
      maVoucher: json['MaVoucher'],
      tenVoucher: json['TenVoucher'],
      giaTriGiam: (json['GiaTriGiam'] as num?)?.toInt() ?? 0,
      giamToiDa: (json['GiamToiDa'] as num?)?.toDouble() ?? 0.0,
      donHangToiThieu: (json['DonHangToiThieu'] as num?)?.toDouble() ?? 0.0,
      soLuongVoucher: (json['SoLuongTong'] as num?)?.toInt() ?? 0,
      ngayBatDau: json['NgayBatDau'] != null 
          ? DateTime.parse(json['NgayBatDau']) 
          : DateTime.now(),
      ngayKetThuc: json['NgayKetThuc'] != null 
          ? DateTime.parse(json['NgayKetThuc']) 
          : DateTime.now(),
      status: json['Status'] ?? 0,
    );
  }
}