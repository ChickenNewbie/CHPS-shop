import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Screen/guimaopt_screen.dart';
import 'package:shopgiaydep_flutter/Service/resetpassword_api.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  void _handleContinue() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar("Vui lòng nhập email", Colors.red);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.sendOtp(email);
      if (!mounted) return;
      _showSnackBar("Mã OTP đã được gửi đến $email", Colors.green);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpVerifyScreen(email: email)),
      );
    } catch (e) {
      _showSnackBar(e.toString().replaceAll("Exception: ", ""), Colors.red);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset('assets/images/image.png', height: 240),
                ),
                  const SizedBox(height: 40),
                Center(
                  child: const Text(
                    "Quên mật khẩu",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                    ),
                const SizedBox(height: 24),
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                  const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    if (_isLoading) setState(() => _isLoading = false);
                  },
                   decoration: InputDecoration(
                    hintText: "Nhập email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Điền email gắn với tài khoản của bạn để nhận mã OTP",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6EDC8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                            "Tiếp tục",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                  const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Quay lại đăng nhập",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        decoration: TextDecoration.underline,
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