import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Service/resetpassword_api.dart';
import 'package:shopgiaydep_flutter/Screen/login_creen.dart';
class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;
  const ResetPasswordScreen({super.key, required this.resetToken});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;
  bool _isLoading = false;
  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }
  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
  void _handleResetPassword() async {
    final pass = _passController.text;
    final confirmPass = _confirmPassController.text;

    if (pass.isEmpty || confirmPass.isEmpty) {
      _showSnackBar("Vui lòng nhập đầy đủ thông tin", Colors.red);
      return;
    }
    if (pass.length < 6) {
      _showSnackBar("Mật khẩu phải có ít nhất 6 ký tự", Colors.red);
      return;
    }
    if (pass != confirmPass) {
      _showSnackBar("Mật khẩu nhập lại không khớp", Colors.red);
      return;
    }
    setState(() => _isLoading = true);
    try {
      //  Gửi Token + Pass mới lên Server
      await _authService.resetPassword(widget.resetToken, pass);
      if (!mounted) return;
      _showSnackBar(
        "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.",
        Colors.green,
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      _showSnackBar(e.toString().replaceAll("Exception: ", ""), Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF8E6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/image.png', height: 160),
                const SizedBox(height: 40),
                const SizedBox(height: 60),
                const Text(
                  "Đặt lại mật khẩu",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Vui lòng nhập mật khẩu mới của bạn.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 30),
                const Text("Mật khẩu mới"),
                const SizedBox(height: 8),
                TextField(
                  controller: _passController,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    hintText: "Nhập mật khẩu mới",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePass = !_obscurePass;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Nhập lại mật khẩu"),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPassController,
                  obscureText: _obscureConfirmPass,
                  decoration: InputDecoration(
                    hintText: "Xác nhận mật khẩu",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPass = !_obscureConfirmPass;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6EDC8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Xác nhận",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}