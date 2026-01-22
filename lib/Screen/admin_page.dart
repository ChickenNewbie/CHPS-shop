import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Components/adminorder_cpn.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Screen/login_creen.dart'; 
import '../Model/admin.dart';
import '../Service/admin_api.dart';
import '../Service/login_api.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String selectedStatus = 'all'; 
  List<Order> orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    
    final data = await AdminApi.getOrders(status: selectedStatus);
    
    debugPrint('Gọi api ($selectedStatus) thành công: ${data.length} đơn');
    if (mounted) {
      setState(() {
        orders = data;
        _isLoading = false;
      });
    }
  }

  void updateOrderStatus(Order order, String newStatus) async {
    bool success = await AdminApi.updateStatus(order.id, newStatus);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!'), backgroundColor: Colors.green));
      _fetchOrders(); 
    }
  }

  void showOrderDetail(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        expand: false,
        builder: (context, scroll) => OrderDetailSheet(order: order, scrollController: scroll, onUpdateStatus: updateOrderStatus),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); 
              await LoginApi.logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'), 
        backgroundColor: const Color(0xFFA3FCBC), 
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Text('Hi, Admin', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.person, color: Colors.orange, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          // Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Chip(
                  label: Text(getStatusText(selectedStatus)),
                  backgroundColor: getStatusColor(selectedStatus).withValues(alpha: 0.2),
                  labelStyle: TextStyle(color: getStatusColor(selectedStatus), fontWeight: FontWeight.bold),
                  side: BorderSide.none,
                ),
                const Spacer(),
                Text(
                  'Tổng: ${orders.length} đơn', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : orders.isEmpty 
              ? _buildEmptyState() 
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) => _buildOrderCard(orders[index]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text('Chưa có đơn hàng nào', style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => showOrderDetail(order),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('#${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(order.status).withValues(alpha: 0.1), 
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text(
                      getStatusText(order.status), 
                      style: TextStyle(color: getStatusColor(order.status), fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.items.length} sản phẩm', 
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)
                  ),
                  Text(
                    formatTien(order.totalAmount), 
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column( 
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: const BoxDecoration(color: Color(0xFFA3FCBC)),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFFA3FCBC),
                  child: Image(
                    image: AssetImage('assets/images/image.png'),
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Admin Manager",
                  style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('Quản lý đơn hàng'),
                
                // [SỬA 3] Thêm mục 'Tất cả' vào đầu danh sách
                _buildMenuItem('Tất cả đơn hàng', 'all', Icons.list_alt),
                const Divider(),
                _buildMenuItem('Chờ xác nhận', 'pending', Icons.hourglass_empty),
                _buildMenuItem('Đã xác nhận', 'confirmed', Icons.check_circle_outline),
                _buildMenuItem('Đang giao', 'shipping', Icons.local_shipping_outlined),
                _buildMenuItem('Hoàn thành', 'completed', Icons.task_alt),
                _buildMenuItem('Đã hủy', 'cancelled', Icons.cancel_outlined),
              ],
            ),
          ),

          const Divider(thickness: 1), 
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red), 
            title: const Text('Đăng xuất', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context); 
              _showLogoutDialog();    
            },
          ),
          const SizedBox(height: 20), 
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[600], letterSpacing: 1.0)),
    );
  }


  Widget _buildMenuItem(String title, String status, IconData icon) {
    bool isSelected = selectedStatus == status;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.green : Colors.grey[600]),
      title: Text(
        title, 
        style: TextStyle(
          color: isSelected ? Colors.green : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
        )
      ),
      tileColor: isSelected ? Colors.green.withValues(alpha: 0.1) : null, 
      onTap: () {
        setState(() => selectedStatus = status);
        Navigator.pop(context); 
        _fetchOrders(); 
      },
    );
  }


  String getStatusText(String status) {
    switch(status) {
      case 'all': return 'Tất cả đơn hàng'; 
      case 'pending': return 'Chờ xác nhận';
      case 'confirmed': return 'Đã xác nhận';
      case 'shipping': return 'Đang giao';
      case 'completed': return 'Hoàn thành';
      case 'cancelled': return 'Đã hủy';
      default: return status;
    }
  }

  Color getStatusColor(String status) {
    switch(status) {
      case 'all': return Colors.blueGrey; 
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'shipping': return Colors.purple;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
  
 
}