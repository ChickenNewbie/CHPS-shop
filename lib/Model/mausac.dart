class MauSac {
  final String urlImage;
  final int maMau;
  final String tenMau;

  MauSac({
    required this.urlImage,
    required this.maMau,
    required this.tenMau
  });

  factory MauSac.fromJson(Map<String, dynamic> json){
    return MauSac(
      urlImage: json['url'], 
      maMau: json['maMau'], 
      tenMau: json['mauSac']
    );
  }
}