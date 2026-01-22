import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/confirmdialog_cpn.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Provider/dathang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Screen/chinhsuaprofile_screen.dart';
import 'package:shopgiaydep_flutter/Screen/danhsachdiachi_screen.dart';
import 'package:shopgiaydep_flutter/Screen/danhsachvoucher.dart';
import 'package:shopgiaydep_flutter/Screen/giohang_screen.dart';
import 'package:shopgiaydep_flutter/Screen/login_creen.dart';
import 'package:shopgiaydep_flutter/Screen/trangthaidonhang_screen.dart';
import 'package:shopgiaydep_flutter/Screen/yeuthich_screen.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final provider = Provider.of<OrderProvider>(context, listen: false);
      provider.fetchOrders(1);
      provider.fetchOrders(2);
      provider.fetchOrders(3);
      provider.fetchOrders(4);
      provider.fetchOrders(5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Cá nhân',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
        centerTitle: true,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildHeaderThongTin(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem("Voucher", Icons.confirmation_number_outlined, (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => DanhSachVoucher(isChonVoucher: false,)));
                        }),
                        _buildStatItem("Yêu thích", Icons.favorite_border, (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => FavoriteScreen()));
                        }),
                        _buildStatItem("Điểm", Icons.stars_outlined, (){}),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Đơn hàng của tôi", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Xem lịch sử >", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Consumer<OrderProvider>(
                    builder: (context, orderProvider, child){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTrangThaiDonHang(
                            Icons.account_balance_wallet_outlined, "Chờ TT", 
                            orderProvider.getSoLuongByStatus(1), 0
                          ),
                          _buildTrangThaiDonHang(
                            Icons.inventory_2_outlined, "Chờ lấy", 
                            orderProvider.getSoLuongByStatus(2), 1
                          ),
                          _buildTrangThaiDonHang(
                            Icons.local_shipping_outlined, "Đang giao", 
                            orderProvider.getSoLuongByStatus(3), 2
                          ),
                          _buildTrangThaiDonHang(
                            Icons.star_border, "Đánh giá", 
                            orderProvider.getSoLuongByStatus(4), 3
                          ),
                          _buildTrangThaiDonHang(
                            Icons.assignment_return_outlined, "Trả hàng", 
                            orderProvider.getSoLuongByStatus(5), 4
                          ),
                        ],
                      );
                    }
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            _buildMenuChucNang()
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderThongTin() {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final username = user?.username ?? 'Khách hàng';
    final url = user?.avatar;
    debugPrint('username: $username, url: $url');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    url != null && url.startsWith('http') 
                      ? url 
                      : 'http://192.168.1.4:3001/uploads/${url ?? "avatar_default.jpg"}'
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Khác hàng VIP tại shop CHPS",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, 
      borderRadius: BorderRadius.circular(8), 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrangThaiDonHang(IconData icon, String label, int soLuong, int tab){
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrangThaiDonHangScreen(tab: tab))),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Icon(icon, color: Colors.black87, size: 28),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
          if(soLuong > 0)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                    soLuong.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
        ],
      ),
    );
  }

  Widget _buildMenuChucNang(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuTile(Icons.person_outline, "Thông tin cá nhân", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));
          }),
          _buildDivider(),
          _buildMenuTile(Icons.history, "Lịch sử mua hàng", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => TrangThaiDonHangScreen(tab: 3)));

          }),
          _buildDivider(),
          _buildMenuTile(Icons.account_balance_wallet_outlined, "Ví & Thanh toán", () {}),
          _buildDivider(),
          _buildMenuTile(Icons.location_on_outlined, "Địa chỉ đã lưu", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => DanhsachdiachiScreen()));

          }),
          _buildDivider(),
          _buildMenuTile(Icons.help_outline, "Trung tâm trợ giúp", () {}),
          _buildDivider(),
          _buildMenuTile(Icons.help_outline, "Đăng xuất", () {_xuLyLogout();}, isLast: true),

        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap, {bool isLast = false}) {
    return ListTile(
      leading: Icon(icon, color: title == "Đăng xuất" ? Colors.red : Colors.black87, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: title == "Đăng xuất" ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      visualDensity: const VisualDensity(vertical: -2), 
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 0.5, indent: 55, endIndent: 16, color: Color(0xFFEEEEEE));
  }


  void _xuLyLogout() async {
    bool confirm = await ConfirmDialog.show(
      context: context,
      title: const Text("Xác nhận đăng xuất"),
      content: const Text("Bạn có chắc chắn muốn rời khỏi ứng dụng không?"),
      confirmButtonText: "Đăng xuất",
      cancelButtonText: "Hủy",
      confirmIcon: Icons.logout,
      cancelIcon: Icons.close,
    );

    if (confirm && mounted) {
      await context.read<AuthProvider>().logout(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}