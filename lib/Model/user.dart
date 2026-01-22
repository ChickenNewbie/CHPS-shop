class User{
  final String username;
  final String email;
  final String diaChi;
  final int? laAdmin;
  final String? avatar;
  final String? soDienThoai;

  User({
    required this.username,
    required this.email,
    required this.diaChi,
    this.laAdmin,
    this.avatar,
    this.soDienThoai
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      diaChi: json['address'] ?? '',
      laAdmin: json['laAdmin'] ?? 0,
      avatar: json['avatar'],
      soDienThoai : json['sdt'] ?? ''
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'address': diaChi, 
      'sdt': soDienThoai, 
      'avatar': avatar,
    };
  }
}