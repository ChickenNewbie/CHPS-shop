import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Screen/admin_page.dart';
import 'package:shopgiaydep_flutter/Screen/register_screen.dart';
import 'package:shopgiaydep_flutter/Screen/trangchu_screen.dart';
import 'package:shopgiaydep_flutter/Service/login_api.dart';
import 'package:shopgiaydep_flutter/Screen/doimatkhau_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }
         
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final String email = txtEmail.text;
      final String password = txtPassword.text;
      final user = await LoginApi.login(
        email: email,
        password: password
      );
      if (user != null) {
        final token = await LoginApi.getToken();
        if (token != null ) {
          context.read<AuthProvider>().saveAuth(token, user);
        }
        final isAdmin = user.laAdmin == 1;
        debugPrint('Is admin (from login response): $isAdmin');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công!'),
            backgroundColor: Colors.green,
          )
        );
          if (isAdmin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainLayout()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.'),
            backgroundColor: Colors.red,
          )
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi hệ thống: $e'),
            backgroundColor: Colors.red,
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
      setState(() => _isLoading = true);
      try {
        final result = await LoginApi.loginWithGoogle();

        if (!mounted) return;

        if (result != null && result['success'] == true) {
          debugPrint("Đăng nhập thành công -> Chuyển trang"); 
          Navigator.pushReplacementNamed(context, '/home');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thành công!'), backgroundColor: Colors.green),
          );
        } else {
          debugPrint("Đăng nhập thất bại hoặc Server trả về false");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thất bại: Lỗi Server'), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        debugPrint("LỖI EXCEPTION: $e"); 
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    Future<void> _handleFacebookLogin() async {
      setState(() => _isLoading = true);
      try {
        final result = await LoginApi.loginWithFacebook();
        if (!mounted) return;
        
        if (result != null && result['success'] == true) {
          Navigator.pushReplacementNamed(context, '/home');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng nhập Facebook thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFA3FCBC),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/image.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'ĐĂNG NHẬP',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    TextFormField(
                      controller: txtEmail,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 18,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        
                      
                        if (!value.trim().toLowerCase().endsWith('@gmail.com')) {
                          return 'Vui lòng nhập đúng định dạng @gmail.com';
                        }
                        

                        if (value.trim().length <= 10) { 
                          return 'Email không hợp lệ';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: txtPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 18,
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value!.length < 6) {
                          return 'Mật khẩu phải có ít nhất 6 ký tự';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterScreen()));
                          },
                          child: const Text(
                            'Chưa có tài khoản ? Đăng ký',
                            style: TextStyle(
                              color: Colors.black, 
                              fontSize: 14,
                              fontWeight: FontWeight.bold, 
                            ),
                          ),
                        ),
                      TextButton(
                          onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (_) => ForgotPasswordScreen()));},
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: 200,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3FC05B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: _isLoading 
                          ? const SizedBox(
                              width: 24, 
                              height: 24, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Text(
                              'Đăng nhập',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.black26, thickness: 2)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.black26, thickness: 2)),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Facebook Button
                        InkWell(
                          onTap: _isLoading ? null : _handleFacebookLogin,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/facebook_logo.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Facebook',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Google Button
                        InkWell(
                          onTap: _isLoading ? null : _handleGoogleLogin,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/google_logo.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }



