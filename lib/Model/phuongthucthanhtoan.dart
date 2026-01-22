class PhuongThucThanhToan {
  final int maPT;
  final String tenPT;
  final String hinhAnh;

  PhuongThucThanhToan({
    required this.maPT,
    required this.tenPT,
    required this.hinhAnh,
  });

  factory PhuongThucThanhToan.fromJson(Map<String, dynamic> json) {
    return PhuongThucThanhToan(
      maPT: json['MaPT'] ?? 0,
      tenPT: json['TenPT'] ?? '',
      hinhAnh: json['HinhAnh'] ?? '',
    );
  }
}