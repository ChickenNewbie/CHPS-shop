import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Screen/thaydoimatkhau_screen.dart';
import 'package:shopgiaydep_flutter/Service/resetpassword_api.dart';
class OtpVerifyScreen extends StatefulWidget {
  final String email;

  const OtpVerifyScreen({super.key, required this.email});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void _handleResendOtp() async {
    setState(() => _isLoading = true);
    try {
      await _authService.sendOtp(widget.email);
      _showSnackBar("Đã gửi lại mã OTP mới", Colors.green);
    } catch (e) {
      _showSnackBar(e.toString().replaceAll("Exception: ", ""), Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleVerify() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showSnackBar("Vui lòng nhập đủ 6 số OTP", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      String token = await _authService.verifyOtp(widget.email, otp);

      if (!mounted) return;
      _showSnackBar("Xác thực thành công!", Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            resetToken: token,
          ), //  Màn hình sau phải nhận biến này
        ),
      );
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
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/image.png', height: 160),
              const SizedBox(height: 40),
              const Text(
                "Xác nhận OTP",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                  "Nhập mã OTP gửi đến email:\n${widget.email}", 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

              const SizedBox(height: 32),
              TextField(
                  controller: _otpController, // Gắn controller
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ), 
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "------",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Resend OTP Logic
                GestureDetector(
                  onTap: _isLoading ? null : _handleResendOtp,
                  child: Text(
                    "Gửi lại mã OTP",
                    style: TextStyle(
                      fontSize: 14,
                      color: _isLoading ? Colors.grey : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Button Confirm
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _handleVerify, // Bấm nút gọi hàm Verify
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
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

                const SizedBox(height: 16),

                const Text(
                  "Vui lòng không tiết lộ OTP của bạn cho bất kỳ ai.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    ),);
  }
}
