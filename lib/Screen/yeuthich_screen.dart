import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Components/productItem_cpn.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:shopgiaydep_flutter/Provider/favorite_provider.dart';
import 'package:shopgiaydep_flutter/Screen/chitietsanpham_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF7F7F7),
        centerTitle: true,
        title: const Text(
          "Danh sách yêu thích",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favProvider, _) {
          final listSP = favProvider.favorites;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: listSP.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    key: const ValueKey("grid"),
                    padding: const EdgeInsets.all(16),
                    itemCount: listSP.length,
                    gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      SanPham sp = listSP[index];
                      return ProductItem(sanPham: sp, isFavoritePage: true,);
                    },
                  ),
          );
        },
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      key: const ValueKey("empty"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 90,
            color: const Color(0xFFFF5A8F).withValues(alpha:0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            "Không có gì trong danh sách yêu thích của ban",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Bạn có thể thêm sản phẩm bằng cách chạm vào trái tim",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
