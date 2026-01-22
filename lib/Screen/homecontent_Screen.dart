import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/danhmuc_cpn.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart'; 
import 'package:shopgiaydep_flutter/Components/mmagecarousel_cpn.dart';
import 'package:shopgiaydep_flutter/Components/productItem_cpn.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/home_provider.dart';
import 'package:shopgiaydep_flutter/Screen/danhmucsanpham_screen.dart';
import 'package:shopgiaydep_flutter/Screen/giohang_screen.dart';
import 'package:shopgiaydep_flutter/Screen/timkiemsanpham_screen.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  static const bgColor = Colors.white;
  double _giaCaoNhat = 1500000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/images/logo.jpg',
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
        ),
        actions: [
          Consumer<GioHangProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Badge(
                  label: Text(
                    provider.totalItems.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                  isLabelVisible: provider.totalItems > 0,
                  largeSize: 18,
                  offset: const Offset(-4, 4),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GioHangScreen()));
                    },
                    icon: const Icon(Icons.shopping_cart, size: 26),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.listBanner.isEmpty && provider.listDM.isEmpty && provider.listSP.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          List<SanPham> filteredProducts = provider.listSP.where((p) {
            return p.giaBan <= _giaCaoNhat;
          }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchProduct()),
                            );
                          },
                          decoration: InputDecoration(
                            label: const Text("Bạn muốn tìm kiếm sản phẩm?",
                                style: TextStyle(fontSize: 15.0, color: Colors.grey)),
                            fillColor: Colors.white,
                            suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.grey)),
                            filled: true,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.black54),
                          onPressed: () {
                            _showFilterDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (provider.listBanner.isNotEmpty)
                    ImageCarousel(
                      images: provider.listBanner.map((b) => b.urlBanner).toList(),
                      height: 160,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  const SizedBox(height: 15),
                  const Text("Danh mục sản phẩm", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: provider.listDM.map((b) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: DanhMucItem(
                          imageUrl: b.urlHinh,
                          onTap: () {
                            int dmId = b.maLoai - 1;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DanhMucScreen(tab: dmId),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Text("Sản phẩm bán chạy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.bestsp.length,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, index) {
                        final sp = provider.bestsp[index];
                        return Container(
                          width: 165,
                          margin: const EdgeInsets.only(right: 12),
                          child: ProductItem(sanPham: sp),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tất cả sản phẩm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Dưới ${formatTien(_giaCaoNhat)}", 
                          style: const TextStyle(color: Colors.green, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length, 
                    itemBuilder: (context, index) {
                      return ProductItem(sanPham: filteredProducts[index]);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF333333),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Lọc sản phẩm theo giá", style: TextStyle(color: Colors.white, fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Khoảng giá tối đa (VNĐ)", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Slider(
                    value: _giaCaoNhat,
                    min: 50000,
                    max: 2000000, 
                    divisions: 39,
                    activeColor: Colors.greenAccent,
                    onChanged: (value) {
                      setDialogState(() {
                        _giaCaoNhat = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("50k", style: TextStyle(color: Colors.white, fontSize: 10)),
                      Text(formatTien(_giaCaoNhat), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Áp dụng", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}