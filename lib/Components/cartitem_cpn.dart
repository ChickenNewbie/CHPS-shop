import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/confirmdialog_cpn.dart'; 
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Model/cartitem.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Screen/chitietsanpham_screen.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  const CartItemWidget({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChiTietSanPhamScreen(id: item.maSP)));
        },
        child: Row(
          children: [
            Checkbox(
              activeColor: Colors.redAccent,
              value: item.isSelected, 
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onChanged: (bool? value){
                context.read<GioHangProvider>().isChecked(item.maCTSP);
              }
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.hinhAnh,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.tenSP,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Phân loại: ${item.mauSac}, ${item.tenSize}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formatTien(item.donGia),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async{
                    bool confirm = await ConfirmDialog.show(
                      context: context,
                      title: const Text("Xác nhận"),
                      content: const Text("Bạn có chắc chắn muốn xóa sản phẩm này?"),
                      confirmButtonText: "Xóa ngay",
                      cancelButtonText: "Hủy",
                    );
                    if(confirm){
                      if(context.mounted){
                        context.read<GioHangProvider>().removeItem(item.maGH, item.maCTSP);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Xoá sản phẩm thành công!")),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _buildQtyBtn(Icons.remove, () {
                        if (item.soLuong > 1) {
                          context.read<GioHangProvider>().updateQuantity(item.maGH, item.maCTSP, -1);
                        }
                      }),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "${item.soLuong}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildQtyBtn(Icons.add, () {
                        context.read<GioHangProvider>().updateQuantity(item.maGH, item.maCTSP, 1);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}