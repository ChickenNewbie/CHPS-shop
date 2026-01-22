import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/confirmdialog_cpn.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Provider/dathang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Screen/giohang_screen.dart';
import 'package:shopgiaydep_flutter/Screen/vietdanhgiasanpham_screen.dart';
import '../Model/order.dart';


class OrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onReload; 

  const OrderCard({super.key, required this.order, this.onTap, this.onReload});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {


  Widget _buildActionButtons(BuildContext context) {
    if (widget.order.status == 4) {
      bool isAllReviewed = widget.order.items.every((item) => item.daDanhGia == true);
      if (isAllReviewed) {
        return OutlinedButton(
          onPressed: () {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chức năng xem lại đang phát triển"),backgroundColor: Colors.green));
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue), 
            foregroundColor: Colors.blue
          ),
          child: const Text("Xem đánh giá"),
        );
      } else {
        return ElevatedButton(
          onPressed: () => _onTapDanhGia(context),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          child: const Text("Đánh giá", style: TextStyle(color: Colors.white)),
        );
      }
    }
    
    if (widget.order.status == 1) {
       return OutlinedButton(
         onPressed: () => _cancelOrder(context, widget.order.maHD),
         style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), foregroundColor: Colors.red),
         child: const Text("Hủy đơn"),
       );
    } 
    else if (widget.order.status == 5) {
       return _btnMuaLai(context);
    }
    
    return const SizedBox.shrink();
  }

  void _onTapDanhGia(BuildContext context) {
    final itemsChua = widget.order.items.where((i) => !i.daDanhGia).toList();
    if (itemsChua.isEmpty) return;
    if (itemsChua.length == 1) {
      _goToWriteReview(itemsChua[0]);
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Chọn sản phẩm (${itemsChua.length})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                   itemCount: itemsChua.length,
                   separatorBuilder: (_,__) => const Divider(),
                   itemBuilder: (ctx, index) {
                      final item = itemsChua[index];
                      return ListTile(
                         contentPadding: EdgeInsets.zero,
                         leading: Image.network(
                           item.hinhAnh, width: 50, height: 50, fit: BoxFit.cover,
                           errorBuilder: (_,__,___) => const Icon(Icons.image),
                         ),
                         title: Text(item.tenSP, maxLines: 1, overflow: TextOverflow.ellipsis),
                         subtitle: Text("Size: ${item.tenSize} - Màu: ${item.mauSac}"),
                         trailing: const Icon(Icons.rate_review_outlined, color: Colors.teal),
                         onTap: () {
                            Navigator.pop(ctx); 
                            _goToWriteReview(item);
                         },
                      );
                   }
                ),
              ),
            ],
          ),
        );
      }
    );
  }


  void _goToWriteReview(dynamic item) async {
     final result = await Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => WriteReviewScreen(item: item))
     );
     if (result == true) {
        if (!mounted) return;
        setState(() {
           item.daDanhGia = true; 
        });
        widget.onReload?.call();
     }
  }

  Widget _buildTrangThaiDonHang(int status) {
    String text = "";
    Color color = Colors.grey;
    switch (status) {
      case 1: text = "Chờ xác nhận"; color = Colors.orange; break;
      case 2: text = "Chờ vận chuyển"; color = Colors.blue; break;
      case 3: text = "Đang giao"; color = Colors.teal; break;
      case 4: text = "Đã giao"; color = Colors.green; break;
      case 5: text = "Đã hủy"; color = Colors.red; break;
    }
    return Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13));
  }

  Widget _btnMuaLai(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleBuyAgain(context),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.orange), 
        foregroundColor: Colors.orange, 
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: const Text("Mua lại"),
    );
  }

  void _handleBuyAgain(BuildContext context) async{
    await context.read<GioHangProvider>().muaLaiDonHang(widget.order.items);
    if(context.mounted){
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã thêm sản phẩm vào giỏ hàng!"),backgroundColor: Colors.green,),
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => const GioHangScreen()));
    }
  }

  void _cancelOrder(BuildContext context, int maHD) async {
    bool confirm = await ConfirmDialog.show(
          context: context,
          title: const Text("Xác nhận"),
          content: const Text("Bạn có chắc chắn muốn huỷ đơn này?"),
          confirmButtonText: "Đồng ý",
          cancelButtonText: "Hủy",
    );
    if(confirm){
      bool success = await context.read<OrderProvider>().cancelOrder(maHD);
      if(success && context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hủy đơn hàng thành công")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spdautien = widget.order.items.isNotEmpty ? widget.order.items[0] : null;
    final tongsp = widget.order.items.length - 1;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mã đơn: #${widget.order.maHD}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                _buildTrangThaiDonHang(widget.order.status),
              ],
            ),
            const Divider(height: 20),
 
            if (spdautien != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      spdautien.hinhAnh,
                      width: 80, height: 80, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) 
                      => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(spdautien.tenSP, maxLines: 2, overflow: TextOverflow.ellipsis, 
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)
                        ),
                        const SizedBox(height: 4),
                        Text("Phân loại: ${spdautien.mauSac}, Size ${spdautien.tenSize}", 
                          style: TextStyle(color: Colors.grey[600], fontSize: 13)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("x${spdautien.soLuong}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(formatTien(spdautien.gia), style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            if (tongsp > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: Text("Xem thêm $tongsp sản phẩm khác", style: TextStyle(color: Colors.grey[600], fontSize: 12))),
              ),
            const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Tổng thanh toán: ",
                    style: const TextStyle(fontSize: 13),
                    children: [
                      TextSpan(
                        text: formatTien(widget.order.tongTienDH),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(context),
              ],
            ),
          ],
        ),
      ),
    );
  }
}