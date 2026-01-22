import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Model/diachi.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Provider/diachi_provider.dart';

class ThemDiaChiScreen extends StatefulWidget {
  const ThemDiaChiScreen({super.key, this.adrressEdit});
  final DiaChi? adrressEdit;
  @override
  State<ThemDiaChiScreen> createState() => _ThemDiaChiScreenState();
}

class _ThemDiaChiScreenState extends State<ThemDiaChiScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isDefault = true;
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _diaChiController = TextEditingController();
  final TextEditingController _chiTietController = TextEditingController();

  @override
  void dispose() {
    _tenController.dispose();
    _diaChiController.dispose();
    _sdtController.dispose();
    _chiTietController.dispose();
    super.dispose();
  }
  @override 
  void initState() {
    super.initState();
    final address = widget.adrressEdit;
    if (address != null) {
      _tenController.text = address.tenNguoiNhan;
       _sdtController.text = address.sdt;
      _diaChiController.text = address.diaChiChiTiet;
      _chiTietController.text = '';
      isDefault = address.laMacDinh == true;
    }else{
       WidgetsBinding.instance.addPostFrameCallback((_){
        final authProvider = context.read<AuthProvider>();
        if(authProvider.user != null){
          setState(() => _tenController.text = authProvider.user!.username);
        }
      });
    }
  }
  void _submitForm() async{
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        "TenNguoiNhan" : _tenController.text,
        "SDT": _sdtController.text,
        "DiaChi": _diaChiController.text,
        "DiaChiChiTiet": _chiTietController.text,
        "LaMacDinh": isDefault ? 1 : 0,
      };
      try{
        final provider = context.read<DiachiProvider>();
        if(widget.adrressEdit == null){
          await provider.themDiaChiMoi(data);
        }else{
          await provider.capNhatDiaChi(
            widget.adrressEdit!.maDC!,
            data,
          );
        }
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.adrressEdit == null 
                ?"Thêm địa chỉ thành công!"  : "Cập nhật địa chỉ thành công"),backgroundColor: Colors.green,),
              );
            Navigator.pop(context);
          }
        }catch(e){
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Lỗi: ${e.toString()}")),
            );
          }
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(
          widget.adrressEdit == null ? "Thêm địa chỉ mới" : "Chỉnh sửa địa chỉ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: widget.adrressEdit == null
        ? []
        : [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await context
                    .read<DiachiProvider>()
                    .xoaDiaChi(widget.adrressEdit!.maDC!);
                if (context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xoá địa chỉ thành công'),backgroundColor: Colors.green,),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],

      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tenLable("Tên"),
              _textField(_tenController, "Nhập tên", (val) {
                if (val == null || val.isEmpty) return "Vui lòng nhập tên người nhận";
                return null;
              }),

              const SizedBox(height: 16),
              _tenLable("Số điện thoại"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Text("VN +84"),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _textField(_sdtController, "Nhập số điện thoại", (val) {
                      if (val == null || val.isEmpty) return "Nhập số điện thoại";
                      if (val.length < 10) return "Số điện thoại quá ngắn";
                      return null;
                    }, keyboardType: TextInputType.phone),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _tenLable("Địa chỉ"),
              _textField(_diaChiController, "Nhập tỉnh/thành, quận/huyện", (val) {
                if (val == null || val.isEmpty) return "Vui lòng nhập địa chỉ";
                return null;
              }),

              const SizedBox(height: 16),
              _tenLable("Chi tiết địa chỉ"),
              _textField(_chiTietController, "Số nhà, tên đường...", null),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Đặt làm mặc định", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Switch(
                    value: isDefault,
                    activeColor: Colors.cyan,
                    onChanged: (value) {
                      setState(() {
                        isDefault = value;
                      });
                    },
                  ),
              ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB6C1), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text("Lưu", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _textField(
    TextEditingController controller, 
    String hint, 
    String? Function(String?)? validator,
    {TextInputType keyboardType = TextInputType.text}
  ) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.red), 
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
    );
  }

  Widget _tenLable(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}