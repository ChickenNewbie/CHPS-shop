class BannerModel {
  final int maBanner;
  final String urlBanner;
  final int idLienKet;
  final int thuTu;
  final int status;

  BannerModel({
    required this.maBanner,
    required this.urlBanner,
    required this.idLienKet,
    required this.thuTu,
    required this.status
  });

  factory BannerModel.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
        "MaBanner" : int maBanner,
        "UrlBanner" : String urlBanner,
        "IdLienKetSP" : int idLienKet,
        "ThuTu" : int thuTu,
        "Status" : int status
      }=> BannerModel(maBanner: maBanner, urlBanner: urlBanner, idLienKet: idLienKet, thuTu: thuTu, status: status),
      _ => throw const FormatException('Lỗi định dạng JSON banner'),
    };
  }
}