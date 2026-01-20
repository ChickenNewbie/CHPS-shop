import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/bienthebottomsheet_cpn.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Provider/chitietsanpham_provider.dart';
import 'package:shopgiaydep_flutter/Provider/favorite_provider.dart';
import 'package:shopgiaydep_flutter/Screen/chitietsanpham_screen.dart';
import 'package:shopgiaydep_flutter/Screen/login_creen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key, 
    required this.sanPham, 
    this.isFavoritePage = false 
  });

  final SanPham sanPham;
  final bool isFavoritePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => ChiTietSanPhamScreen(id: sanPham.maSP))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      sanPham.anhDaiDien,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  
                  if (isFavoritePage)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: (){
                          context.read<FavoriteProvider>().handleFavorite(sanPham.maSP);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).clearSnackBars(); 
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Đã xóa sản phẩm ra khỏi yêu thích"),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating, 
                                backgroundColor: Colors.green,
                              )
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 16,
                            color: Color(0xFFFF5A8F),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sanPham.tenSP,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        sanPham.diemDanhGia.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        "Đã bán ${sanPham.luotBan}",
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTien(sanPham.giaBan),
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          _themGioHangTuHome(context, sanPham.maSP);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5A8F).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart, 
                            color: Color(0xFFFF5A8F), 
                            size: 20
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _themGioHangTuHome(BuildContext context, int maSP) async {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng đăng nhập để thêm vào giỏ hàng!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return; 
    }
    final detailProvider = context.read<ChiTietSanPhamProvider>();
    await detailProvider.fetchChiTietSanPham(maSP);
    
    if (detailProvider.chitietsp != null) {
      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white, 
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => BienTheSanPhamBottonSheet(
            sp: detailProvider.chitietsp!,
            title: "THÊM VÀO GIỎ HÀNG",
          ),
        );
      }
    }
  }
}