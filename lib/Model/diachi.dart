class DiaChi {
  final int? maDC;
  final String tenNguoiNhan;
  final String sdt;
  final String diaChiChiTiet;
  final bool laMacDinh;

  DiaChi({
    this.maDC,
    required this.tenNguoiNhan,
    required this.sdt,
    required this.diaChiChiTiet,
    this.laMacDinh = false,
  });


  factory DiaChi.fromJson(Map<String, dynamic> json) {
    return DiaChi(
      maDC: json['MaDC'] is int
            ? json['MaDC']
            : int.tryParse(json['MaDC']?.toString() ?? ''),
      tenNguoiNhan: json['TenNguoiNhan'] ?? '',
      sdt: json['SDT'] ?? '',
      diaChiChiTiet: json['DiaChiChiTiet'] ?? '',
      laMacDinh: json['LaMacDinh'] == 1,
    );
  }

   DiaChi copyWith({
    int? maDC,
    String? tenNguoiNhan,
    String? sdt,
    String? diaChiChiTiet,
    bool? laMacDinh,
  }) {
    return DiaChi(
      maDC: maDC ?? this.maDC,
      tenNguoiNhan: tenNguoiNhan ?? this.tenNguoiNhan,
      sdt: sdt ?? this.sdt,
      diaChiChiTiet: diaChiChiTiet ?? this.diaChiChiTiet,
      laMacDinh: laMacDinh ?? this.laMacDinh,
    );
  }

  
}