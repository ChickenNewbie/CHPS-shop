import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/productItem_cpn.dart';
import 'package:shopgiaydep_flutter/Provider/home_provider.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final TextEditingController _controller = TextEditingController();
  final Color bakColor = Colors.white;

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeScreenProvider>();

    return Scaffold(
      backgroundColor: bakColor,
      appBar: AppBar(
        backgroundColor: bakColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm giày dép...',
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty 
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _controller.clear();
                    provider.searchResultProduct(""); 
                  },
                ) 
              : null,
          ),
          onChanged: (value) {
            provider.searchResultProduct(value);
            setState(() {}); 
          },
        ),
      ),
      body: provider.searchSP.isEmpty
          ? _buildProductEmpty()
          : _buildProductSearch(provider),
    );
  }

  Widget _buildProductEmpty() {
    return const Center(
      child: Text("Nhập tên sản phẩm để bắt đầu tìm kiếm",
          style: TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildProductSearch(HomeScreenProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: provider.searchSP.length,
      itemBuilder: (context, index) {
        return ProductItem(sanPham: provider.searchSP[index]);
      },
    );
  }
}