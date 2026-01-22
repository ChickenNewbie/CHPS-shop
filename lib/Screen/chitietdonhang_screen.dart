import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/confirmdialog_cpn.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart'; 
import 'package:shopgiaydep_flutter/Provider/dathang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Screen/giohang_screen.dart';
import '../Model/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const   OrderDetailScreen({super.key, required this.order});

  
  void _handleReBuy(BuildContext context) async{
    await context.read<GioHangProvider>().muaLaiDonHang(order.items);
    if(context.mounted){
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã thêm sản phẩm vào giỏ hàng!"),backgroundColor: Colors.green,),
      );
      Navigator.push(
        context, 
          MaterialPageRoute(builder: (_) => const GioHangScreen()) 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đơn hàng"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTrangThai(order.status),
            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            _buildDiaChiNhanHang(),

            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            _builDanhSachDonHang(),

            const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

            _buildThanhToan(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(context)
    );
  }

  Widget _builDanhSachDonHang() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text("Danh sách sản phẩm", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(),
          itemCount: order.items.length,
          itemBuilder: (context, index) {
            final item = order.items[index];
            return ListTile(
              leading: Image.network(item.hinhAnh, width: 60, height: 60, fit: BoxFit.cover),
              title: Text(item.tenSP, style: const TextStyle(fontSize: 14)),
              subtitle: Text("Phân loại: ${item.mauSac}, Size ${item.tenSize}\nx${item.soLuong}"),
              trailing: Text(formatTien(item.gia), style: const TextStyle(color: Colors.red)),
            );
          },
        ),
      ],
    );
  }

 Widget _buildDiaChiNhanHang() {
  return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.red),
      title: const Text(
        "Địa chỉ nhận hàng", 
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${order.tenNguoiNhan} | ${order.soDienThoai}",
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              order.diaChiGiaoHang,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThanhToan() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _rowInfo("Tổng tiền hàng", formatTien(order.tongTienDH + order.giaGiam - order.phiShip)),
          _rowInfo("Phí vận chuyển", formatTien(order.phiShip)),
          _rowInfo("Giảm giá", "-${formatTien(order.giaGiam)}", isDiscount: true),
          const Divider(),
          _rowInfo("Thành tiền", formatTien(order.tongTienDH), isTotal: true),
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String value, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(value, style: TextStyle(
            color: isDiscount ? Colors.orange : (isTotal ? Colors.red : Colors.black),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 14
          )),
        ],
      ),
    );
  }

  Widget _buildTrangThai(int status) {
    if (status == 5) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red[50],
        child: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 10),
            Text("Đơn hàng này đã bị hủy", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
    List<String> statuses = ["Đã đặt", "Đóng gói", "Đang giao", "Thành công"];
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        color: Colors.white,
        child: Row(
          children: List.generate(statuses.length, (index) {
            int step = index + 1; 
            bool isCompleted = status >= step;
            bool isLast = index == statuses.length - 1;
            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Container(height: 2, color: index == 0 ? Colors.transparent : (isCompleted ? Colors.green : Colors.grey[300]))),
                      Icon(
                        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 20,
                        color: isCompleted ? Colors.green : Colors.grey,
                      ),
                      Expanded(child: Container(height: 2, color: isLast ? Colors.transparent : (status > step ? Colors.green : Colors.grey[300]))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    statuses[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    }
    
  void _cancelOrder(BuildContext context, int maHD)async{
    bool confirm =  await ConfirmDialog.show(
          context: context,
          title: const Text("Xác nhận"),
          content: const Text("Bạn có chắc chắn muốn huỷ đơn này?"),
          confirmButtonText: "Đồng ý",
          cancelButtonText: "Hủy",
    );
    if(confirm){
      bool success = false;
      if(context.mounted){
       success = await context.read<OrderProvider>().cancelOrder(maHD);
      }
      if(success){
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hủy đơn hàng thành công")),
          );
          Navigator.pop(context);
        }
      }else{
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hủy đơn hàng thất bại")),
          );
        }
      }
    }
  }
 
  Widget? _buildBottomAction(BuildContext context) {
    if (order.status == 1) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () { _cancelOrder(context, order.maHD); },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, 
            padding: const EdgeInsets.symmetric(vertical: 15)
          ),
          child: const Text("Hủy Đơn Hàng", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }

    if (order.status == 5 || order.status == 4) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () => _handleReBuy(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, 
            padding: const EdgeInsets.symmetric(vertical: 15)
          ),
          child: const Text("Mua Lại Đơn Này", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }
    return null;
  }
}