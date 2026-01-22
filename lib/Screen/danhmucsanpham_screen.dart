import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Components/productItem_cpn.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:shopgiaydep_flutter/Provider/danhmucsanpham_provider.dart';

class DanhMucScreen extends StatefulWidget {
  const DanhMucScreen({super.key, required this.tab});
  final int tab;
  @override
  State<DanhMucScreen> createState() => _DanhMucScreenState();
}

class _DanhMucScreenState extends State<DanhMucScreen> with TickerProviderStateMixin {
  late TabController _typeTabController;
  String selectedBrand = "Tất cả";
  double _giaCaoNhat = 1500000;
  List<String> _getBrands(int tab){
    if(tab == 0){
      return ["Tất cả", "Nike", "Adidas", "Thể thao", "Vans", "Puma"];
    }
    return ["Tất cả", "Dép quai", "Doctor", "Dép đúc", "Crocs", "Sục"];
  }
  @override
  void initState() {
    super.initState();
    _typeTabController = TabController(
      length: 2, 
      vsync: this,
      initialIndex: widget.tab
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      int id = widget.tab == 0 ? 1 : 2;
      context.read<DanhMucProvider>().fetchDataCategories(id);
    });

    _typeTabController.addListener(() {
      if (!_typeTabController.indexIsChanging) {
        int maLoai = _typeTabController.index == 0 ? 1 : 2;
        context.read<DanhMucProvider>().fetchDataCategories(maLoai);
        setState(() => selectedBrand = 'Tất cả');
      }
    });
  }

  @override
  void dispose() {
    _typeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DanhMucProvider>();
    List<SanPham> prodcutsCate = provider.listSP;
    
    prodcutsCate = provider.listSP.where((p){
        bool sp = selectedBrand == "Tất cả" || p.tenSP.toLowerCase().contains(selectedBrand.toLowerCase());
        bool gia = p.giaBan <= _giaCaoNhat;
        return sp && gia;
    }).toList();
    
    final curBrand = _getBrands(_typeTabController.index);
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Danh Mục Sản Phẩm",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(130),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TabBar(
                        controller: _typeTabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF3FC05B).withValues(alpha: 0.2),
                        ),
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.black54,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Tab(text: "Giày"),
                          Tab(text: "Dép"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: curBrand.length,
                        itemBuilder: (context, index) {
                          String brandName = curBrand[index];
                          bool isSelected = selectedBrand == brandName;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(brandName),
                              selected: isSelected,
                              onSelected: (val) {
                                setState(() => selectedBrand = brandName);
                              },
                              selectedColor: const Color(0xFF3FC05B).withValues(alpha: 0.2),
                              labelStyle: TextStyle(
                                color: isSelected ?  const Color(0xFF3FC05B) : Colors.black,
                                fontSize: 13,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey[200]!),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${prodcutsCate.length} sản phẩm", 
                      style: const TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => _showFilterDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Text("Lọc & Sắp xếp ", style: TextStyle(fontSize: 12)),
                          Icon(Icons.tune, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: provider.isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF333333)))
                : provider.listSP.isEmpty
                  ? const Center(child: Text("Không có sản phẩm nào"))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,          
                        childAspectRatio: 0.7,    
                        crossAxisSpacing: 10,       
                        mainAxisSpacing: 10,
                      ),
                      itemCount: prodcutsCate.length,
                      itemBuilder: (context, index) {
                        final SanPham sp = prodcutsCate[index];
                        return ProductItem(sanPham: sp);
                      },
                    ),
            ),
          ],
        ),
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
              title: const Text("Lọc sản phẩm", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Khoảng giá (VNĐ)", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Slider(
                    value: _giaCaoNhat,
                    min: 50000,
                    max: 1500000,
                    divisions: 20,
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
                      const Text("50.000đ", style: TextStyle(color: Colors.white, fontSize: 10)),
                      Text(formatTien(_giaCaoNhat), style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Áp dụng"),
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