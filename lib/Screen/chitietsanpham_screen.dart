import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/bienthebottomsheet_cpn.dart';
import 'package:shopgiaydep_flutter/Components/danhgia_cpn.dart';
import 'package:shopgiaydep_flutter/Components/danhgiatatca.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Components/mmagecarousel_cpn.dart';
import 'package:shopgiaydep_flutter/Model/chitietsanpham.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Provider/chitietsanpham_provider.dart';
import 'package:shopgiaydep_flutter/Provider/danhgiasanpham_provider.dart';
import 'package:shopgiaydep_flutter/Provider/favorite_provider.dart';
import 'package:shopgiaydep_flutter/Screen/login_creen.dart';


class ChiTietSanPhamScreen extends StatefulWidget{
  const ChiTietSanPhamScreen({super.key, required this.id});
  final int id;

  @override
  State<ChiTietSanPhamScreen> createState() => _ChiTietSanPhamState();
}

class _ChiTietSanPhamState extends State<ChiTietSanPhamScreen>{
  static const bgColor = Colors.white; 
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<ChiTietSanPhamProvider>().fetchChiTietSanPham(widget.id);
      context.read<DanhGiaProvider>().fetchReviewAll(widget.id);
      final auth = context.read<AuthProvider>();
      if(auth.isAuthenticated){
        context.read<FavoriteProvider>().loadFavorites();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Chi tiết sản phẩm',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
        centerTitle: true,
      ),
      body: Consumer<ChiTietSanPhamProvider>(
        builder: (context, provider, child){
          if(provider.isLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if(provider.chitietsp == null){
            return const Center(child: Text('Không tìm thấy sản phẩm'));
          }
          final sp = provider.chitietsp!;
          final List<String> images = sp.images.map((e)=>e.urlImage).toList();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCarousel(images: images, height: 280.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Text(
                        sp.tenSP,
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          "${sp.diemDanhGia}", 
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" (${sp.tongSoDanhGia} đánh giá)"), 
                        const Spacer(),
                        Text(
                          "Đã bán: ${sp.luotBan}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text("Giá bán: "), 
                        const SizedBox(width: 4),
                        Text(
                          formatTien(sp.listBienThe[0].donGia),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),

                        Consumer<FavoriteProvider>(
                          builder: (context, favProvider, child) {
                            final bool isFav = favProvider.isExist(sp.maSP);
                            return IconButton(
                              onPressed: () async {
                                final auth = context.read<AuthProvider>();
                                if (!auth.isAuthenticated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Vui lòng đăng nhập để yêu thích sản phẩm")),
                                  );
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                                  return;
                                }
                                await favProvider.handleFavorite(sp.maSP);
                              },
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey,
                                size: 28,
                              ),
                            );
                          }
                        )
                      ],
                    ),
                    ]
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  color:  Colors.teal[300],
                  height: 50.0,
                  child: Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text("     CHI TIẾT SẢN PHẨM", 
                    style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                      Text("Mô tả sản phẩm: ${sp.moTa}", style: TextStyle(fontSize: 16.0, color: Colors.black)),
                      Center(child: Text("[Vui lòng đọc kỹ thông tin chi tiết trước khi mua nó!]")),
                      Text("""Chào mừng bạn đến với cửa hàng của chúng tôi. Sự ủng hộ của bạn là động lực to lớn nhất của shop chúng tôi. Tất cả các sản phẩm tại shop đều đảm bảo chất lượng. Hãy an tâm mua sắm nếu bạn cần.""",
                        style :TextStyle(fontSize: 14.0, color: Colors.black)),
                      Center(
                        child: Text("***** Xin chân thành cảm ơn *****"),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  color:  Colors.teal[300],
                  height: 50.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text("     Đánh giá sản phẩm", 
                        style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                      Spacer(),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> DanhGia(id: widget.id)));
                      }, child: Text('Xem thêm...'))
                    ],
                  ),
                ),
                Consumer<DanhGiaProvider>(
                  builder: (context, provider, child){
                     if(provider.loading){
                      return const Center(child: CircularProgressIndicator());
                      }
                     final reviews = provider.danhGia?.take(2).toList();
                     if (reviews == null || reviews.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: Text('Sản phẩm này chưa có đánh giá')),
                        );
                     }
                     return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(), 
                      itemCount: reviews.length,
                      itemBuilder: (context, index){
                        final review = reviews[index];
                        return DanhGiaItem(item: review);
                      }, 
                    );

                  }
                )
              ],
            ),
          );

        }
      ),
      bottomNavigationBar: Consumer<ChiTietSanPhamProvider>(
        builder: (context, provider, child){
          if(provider.isLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if(provider.chitietsp == null){
            return const Center(child: Text('Không tìm thấy sản phẩm'));
          }
          final sp = provider.chitietsp!;
        return Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showBottomSheet(context, sp, 'THÊM VÀO GIỎ HÀNG');
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Thêm vào giỏ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4DD0B0), 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
              const SizedBox(width: 12),
              Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showBottomSheet(context, sp, 'MUA NGAY');
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Mua ngay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            ],
          ),
        );
    }
      )
      
    );
  }

  void _showBottomSheet(BuildContext context, ChiTietSanPham sp, String title) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => BienTheSanPhamBottonSheet(sp: sp, title: title),
      );
    }

  

}
