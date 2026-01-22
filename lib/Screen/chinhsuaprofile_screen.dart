import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Model/user.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Provider/diachi_provider.dart';
import 'package:shopgiaydep_flutter/Screen/changepassword_profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String userName = "";
  String userEmail = "";
  String userPhone = "";
  String userAddress = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated && auth.user != null) {
        setState(() {
          userName = auth.user!.username;
          userEmail = auth.user!.email;
          userAddress = auth.user?.diaChi ?? '';
          userPhone = auth.user?.soDienThoai ?? '';
        });
      }
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    }
    final email = value.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(email)) {
      return 'Email không đúng định dạng';
    }
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      return 'Vui lòng sử dụng địa chỉ @gmail.com';
    }
    if (email.length <= 10) { 
      return 'Vui lòng nhập tên email trước @gmail.com';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Số điện thoại không được để trống';
    final phoneRegex = RegExp(r'^0\d{9}$'); 
    if (!phoneRegex.hasMatch(value)) {
      return 'SĐT phải bắt đầu bằng 0 và có 10 số';
    }
    return null;
  }

  void _showEditModal({
    required String title,
    required String currentValue,
    required Function(String) onSave,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator, 
  }) {
    final controller = TextEditingController(text: currentValue);
    String? errorText; 

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sửa $title",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: keyboardType,
                    onChanged: (value) {

                      if (errorText != null) {
                        setStateModal(() {
                          errorText = null;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Nhập $title mới",
                      errorText: errorText, 
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF4DD0B0), width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DD0B0)),
                      onPressed: () {
                        final value = controller.text.trim();
                    
                        if (validator != null) {
                          final error = validator(value);
                          if (error != null) {
                            setStateModal(() {
                              errorText = error; 
                            });
                            return; 
                          }
                        }
                        onSave(value);
                        Navigator.pop(context);
                      },
                      child: const Text("LƯU THAY ĐỔI",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text("Thông tin cá nhân",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildInputField(
                      label: "Tên",
                      value: userName,
                      icon: Icons.person_outline,
                      onTap: () => _showEditModal(
                        title: "Tên",
                        currentValue: userName,
                        onSave: (val) => setState(() => userName = val),
                        validator: (val) => (val == null || val.isEmpty) ? "Tên không được để trống" : null,
                      ),
                    ),
                    const Divider(height: 1),
                    _buildInputField(
                      label: "Email",
                      value: userEmail,
                      icon: Icons.email_outlined,
                      onTap: () => _showEditModal(
                        title: "Email",
                        currentValue: userEmail,
                        keyboardType: TextInputType.emailAddress,
                        onSave: (val) => setState(() => userEmail = val),
                        validator: _validateEmail, 
                      ),
                    ),
                    const Divider(height: 1),
                    _buildInputField(
                      label: "Địa chỉ",
                      value: userAddress.isEmpty ? 'Chưa cập nhật' : userAddress,
                      icon: Icons.keyboard_arrow_down,
                      onTap: () => _showEditModal(
                        title: "Địa chỉ",
                        currentValue: userAddress,
                        keyboardType: TextInputType.streetAddress,
                        onSave: (val) => setState(() => userAddress = val),
                      ),
                    ),
                    const Divider(height: 1),
                    _buildInputField(
                      label: "Số điện thoại",
                      value: userPhone.isEmpty ? 'Chưa cập nhật' : userPhone,
                      icon: Icons.phone_android_outlined,
                      onTap: () => _showEditModal(
                        title: "Số điện thoại",
                        currentValue: userPhone,
                        keyboardType: TextInputType.phone,
                        onSave: (val) => setState(() => userPhone = val),
                        validator: _validatePhone, 
                      ),
                    ),
                    const Divider(height: 1),
                    _buildActionField(
                        label: "Đổi mật khẩu", icon: Icons.lock_outline),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final auth = context.read<AuthProvider>();
                    
                    if (_validateEmail(userEmail) != null || _validatePhone(userPhone) != null) {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Thông tin không hợp lệ, vui lòng kiểm tra lại"), backgroundColor: Colors.red),
                        );
                        return;
                    }

                    final updateProfile = User(
                        username: userName,
                        email: userEmail,
                        diaChi: userAddress,
                        soDienThoai: userPhone,
                        avatar: _getFileNameOnly(
                            auth.user?.avatar ?? 'avatar_default.jpg'));
                    try {
                      await auth.updateProfile(updatedInfo: updateProfile);
                      if (userAddress.isNotEmpty && userPhone.isNotEmpty) {
                        Map<String, dynamic> dataAddress = {
                          "TenNguoiNhan": userName,
                          "SDT": userPhone,
                          "DiaChi": userAddress,
                          "DiaChiChiTiet": userAddress,
                          "LaMacDinh": 1,
                        };
                        await context
                            .read<DiachiProvider>()
                            .themDiaChiMoi(dataAddress);
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Đã cập nhật hồ sơ và đồng bộ vào sổ địa chỉ!"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Cập nhật thất bại: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4DD0B0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("CẬP NHẬT THÔNG TIN",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFileNameOnly(String path) {
    if (path.contains('/uploads/')) {
      return path.split('/uploads/').last;
    }
    return path;
  }

  Widget _buildInputField(
      {required String label,
      required String value,
      required IconData icon,
      VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(label,
          style: const TextStyle(color: Colors.grey, fontSize: 13)),
      subtitle: Text(value,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      trailing: const Icon(Icons.edit, color: Color(0xFF4DD0B0), size: 18),
      onTap: onTap,
    );
  }

  Widget _buildHeader() {
    final auth = context.watch<AuthProvider>();
    final url = auth.user?.avatar;
    return Center(
      child: InkWell(
        onTap: _pickerImage,
        child: Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4DD0B0), width: 3),
                image: DecorationImage(
                  image: NetworkImage(url != null && url.startsWith('http')
                      ? url
                      : 'http://192.168.1.4:3001/uploads/${url ?? "avatar_default.jpg"}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF4DD0B0),
                radius: 18,
                child:
                    const Icon(Icons.camera_alt, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionField({required String label, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(label,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => ChangePasswordProfile()));
      },
    );
  }

  Future<void> _pickerImage() async {
    final XFile? pickerFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      imageQuality: 80,
    );

    if (pickerFile != null) {
      File imageFile = File(pickerFile.path);
      try {
        final auth = context.read<AuthProvider>();
        await auth.uploadAvatar(imageFile);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Cập nhật ảnh đại diện thành công!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}