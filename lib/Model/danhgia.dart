
class DanhGia {
  final int maDG;
  final int soSao;
  final String noiDung;
  final String? hinhAnhDG;
  final DateTime ngayDanhGia;
  final String username;
  final String tenSize;
  final String mauSac;

  DanhGia({
    required this.maDG,
    required this.soSao,
    required this.noiDung,
    this.hinhAnhDG,
    required this.ngayDanhGia,
    required this.username,
    required this.tenSize,
    required this.mauSac
  });

  factory DanhGia.fromJson(Map<String, dynamic> json) {
    return DanhGia(
      maDG: json['MaDG'],
      soSao: json['SoSao'] ?? 0,
      noiDung: json['NoiDung'] ?? '',
      hinhAnhDG: json['HinhAnhDG'] ?? '',
      ngayDanhGia: DateTime.parse(json['NgayDanhGia']),
      username: json['Username'],
      tenSize: json['TenSize'],
      mauSac: json['MauSac']
    );
  }
}
