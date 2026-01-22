class DanhMuc{
  final int maLoai;
  final String tenLoaiDM;
  final String urlHinh;

  DanhMuc({
    required this.maLoai,
    required this.tenLoaiDM,
    required this.urlHinh
  });

  factory DanhMuc.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        "MaLoai" : int maLoai,
        "TenLoaiSP" : String tenLoaiDM,
        "Icon" : String urlHinh
      } => DanhMuc(maLoai: maLoai, tenLoaiDM: tenLoaiDM, urlHinh: urlHinh),
      _ => throw Exception('Convert from json category is failed')
    };
  }
}