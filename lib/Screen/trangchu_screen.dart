import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/home_provider.dart';
import 'package:shopgiaydep_flutter/Screen/canhan_screen.dart';
import 'package:shopgiaydep_flutter/Screen/danhmucsanpham_screen.dart';
import 'package:shopgiaydep_flutter/Screen/danhsachvoucher.dart';
import 'package:shopgiaydep_flutter/Screen/giohang_screen.dart';
import 'package:shopgiaydep_flutter/Screen/homecontent_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  final List<Widget> _pages = [
    const HomeContentScreen(),
    const DanhMucScreen(tab: 0),
    const GioHangScreen(),
    const DanhSachVoucher(isChonVoucher: false,),
    const ProfileScreen()
  ];
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeScreenProvider>().fetchDataHome();
      context.read<GioHangProvider>().fetchCart();
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white, 
        elevation: 10, 
        shadowColor: Colors.black,
        indicatorColor: const Color(0xFF3FC05B).withValues(alpha: 0.2),
        onDestinationSelected: (int index){
          setState(() => currentPageIndex = index);
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined), 
            label: 'Home'
          ),
           NavigationDestination(
            selectedIcon: Icon(Icons.category),
            icon: Icon(Icons.category_outlined), 
            label: 'Category'
          ),
          NavigationDestination(
            selectedIcon: _buildCartBadge(true),  
            icon: _buildCartBadge(false),         
            label: 'Cart',
          ),
           NavigationDestination(
            selectedIcon: Icon(Icons.confirmation_number),
            icon: Icon(Icons.confirmation_number_outlined), 
            label: 'Voucher'
          ),
           NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline), 
            label: 'Person'
          )
        ]
      ),
    );
  }

  Widget _buildCartBadge(bool isSelected) {
    return Consumer<GioHangProvider>(
      builder: (context, provider, child) {
        return Badge(
          label: Text(provider.totalItems.toString()),
          isLabelVisible: provider.totalItems > 0,
          child: Icon(isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined),
        );
      },
    );
  }
}
