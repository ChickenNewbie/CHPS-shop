import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Model/chitietsanpham.dart';
import 'package:shopgiaydep_flutter/Model/bienthesanpham.dart';
import 'package:shopgiaydep_flutter/Model/cartitem.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Screen/login_creen.dart';
import 'package:shopgiaydep_flutter/Screen/thanhtoan_screen.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';

class BienTheSanPhamBottonSheet extends StatefulWidget {
  final ChiTietSanPham sp;
  final String title;

  const BienTheSanPhamBottonSheet({super.key, required this.sp, required this.title});

  @override
  State<BienTheSanPhamBottonSheet> createState() => _BienTheSanPhamBottonSheetState();
}

class _BienTheSanPhamBottonSheetState extends State<BienTheSanPhamBottonSheet> {
  int _count = 1;
  String? chonMau;
  String? chonSize;
  BienTheSanPham? chonBienThe;

  @override
  void initState() {
    super.initState();
    _khoiTaoBienThe();
  }

  void _khoiTaoBienThe() {
    final khoiTao = widget.sp.listBienThe.firstWhere(
      (v) => v.soLuongTon > 0,
      orElse: () => widget.sp.listBienThe.first,
    );
    chonBienThe = khoiTao;
    chonMau = khoiTao.mauSac;
    chonSize = khoiTao.tenSize;
  }

  String _layAnhTheoMau() {
    if (chonMau == null || widget.sp.images.isEmpty) return widget.sp.images[0].urlImage;
    return widget.sp.images.firstWhere(
      (img) => img.tenMau == chonMau,
      orElse: () => widget.sp.images[0],
    ).urlImage;
  }

  void _chonThuocTinh({String? color, String? size}) {
    setState(() {
      if (color != null) chonMau = color;
      if (size != null) chonSize = size;
      try {
        chonBienThe = widget.sp.listBienThe.firstWhere(
          (v) => v.mauSac == chonMau && (chonSize == null || v.tenSize == chonSize),
        );
      } catch (e) {
        chonBienThe = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(_layAnhTheoMau(), width: 100, height: 100, fit: BoxFit.cover),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatTien(chonBienThe?.donGia ?? widget.sp.listBienThe[0].donGia),
                      style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Kho: ${chonBienThe?.soLuongTon ?? widget.sp.listBienThe[0].soLuongTon}"),
                ],
              )
            ],
          ),
          const Divider(),
          const Text("Màu sắc"),
          Wrap(
            spacing: 8,
            children: widget.sp.mauSac.map((color) => ChoiceChip(
              label: Text(color),
              selected: chonMau == color,
              onSelected: (val) => _chonThuocTinh(color: color),
            )).toList(),
          ),
          const SizedBox(height: 16),
          const Text("Kích thước"),
          Wrap(
            spacing: 8,
            children: widget.sp.sizes.map((size) => ChoiceChip(
              label: Text(size),
              selected: chonSize == size,
              onSelected: (val) => _chonThuocTinh(size: size),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Số lượng", style: TextStyle(fontSize: 16)),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], 
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _count > 1 ? () => setState(() => _count--) : null,
                      icon: const Icon(Icons.remove, size: 20, color: Colors.black87),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "$_count",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: (chonBienThe != null && _count < chonBienThe!.soLuongTon)
                          ? () => setState(() => _count++)
                          : null,
                      icon: const Icon(Icons.add, size: 20, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA3FCBC), minimumSize: const Size(double.infinity, 50)),
            onPressed: (chonBienThe != null && chonBienThe!.soLuongTon > 0) ? () async {
              final auth = context.read<AuthProvider>();
              if (!auth.isAuthenticated) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                return;
              }
              if (widget.title == "THÊM VÀO GIỎ HÀNG") {
                await context.read<GioHangProvider>().addToCart(chonBienThe!.maCTSP, _count);
                if(context.mounted){
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Đã thêm vào giỏ hàng!"),backgroundColor: Colors.green,));
                }
              } else {
                Navigator.pop(context);
                CartItem itemMuaNgay = CartItem(
                  maCTGH: 0, 
                  maGH: 0, 
                  maCTSP: chonBienThe!.maCTSP, soLuong: _count,
                  maSP: widget.sp.maSP, 
                  tenSP: widget.sp.tenSP, 
                  tenSize: chonSize!,
                  mauSac: chonMau!, 
                  donGia: chonBienThe!.donGia.toDouble(),
                  hinhAnh: _layAnhTheoMau(), 
                  isSelected: true
                );
                Navigator.push(context, MaterialPageRoute(builder: (_) => ThanhtoanScreen(danhSachChon: [itemMuaNgay], tongTien: (chonBienThe!.donGia * _count).toDouble())));
              }
            } : null,
            child: Text(widget.title),
          )
        ],
      ),
    );
  }
}