import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Model/admin.dart';

class OrderDetailSheet extends StatelessWidget {
  final Order order;
  final ScrollController scrollController;
  final Function(Order, String) onUpdateStatus;

  const OrderDetailSheet({
    super.key,
    required this.order,
    required this.scrollController,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),

          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Đơn hàng #${order.id}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    _buildStatusBadge(order.status),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.person, 'Người nhận', order.customerName),
                      _buildInfoRow(Icons.phone, 'Số điện thoại', order.customerPhone),
                      _buildInfoRow(Icons.location_on, 'Địa chỉ', order.address, isMultiLine: true),
                      _buildInfoRow(Icons.calendar_today, 'Ngày đặt', _formatDate(order.orderDate)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text("Sản phẩm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                ...order.items.map((item) => _buildProductItem(item)),
                
                const Divider(height: 30),

                _buildMoneyRow('Tổng tiền hàng', order.totalAmount),
                _buildMoneyRow('Phí vận chuyển', order.shipping), // Nhớ thêm trường này vào Model Order
                if (order.discount > 0)
                  _buildMoneyRow('Giảm giá (Voucher)', -order.discount, isDiscount: true),
                
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Thành tiền', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      formatTien(order.totalAmount + order.shipping - order.discount), 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }
  Widget _buildActionButtons(BuildContext context) {
    if (order.status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: _buildButton(context, 'Từ chối', Colors.red, Colors.red, isOutlined: true, onTap: () {
              _confirmDialog(context, 'Hủy đơn hàng này?', 'cancelled');
            }),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildButton(context, 'Duyệt đơn', Colors.orange, Colors.white, onTap: () {
              _confirmDialog(context, 'Xác nhận duyệt đơn hàng?', 'confirmed');
            }),
          ),
        ],
      );
    } 
    else if (order.status == 'confirmed') {
      return Row(
        children: [
          Expanded(
            child: _buildButton(context, 'Hủy đơn', Colors.red, Colors.red, isOutlined: true, onTap: () {
              _confirmDialog(context, 'Khách muốn hủy đơn này?', 'cancelled');
            }),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildButton(context, 'Giao hàng', Colors.blue, Colors.white, onTap: () {
              _confirmDialog(context, 'Bắt đầu giao hàng?', 'shipping');
            }),
          ),
        ],
      );
    } 
    else if (order.status == 'shipping') {
      return SizedBox(
        width: double.infinity,
        child: _buildButton(context, 'Đã giao thành công', Colors.green, Colors.white, onTap: () {
          _confirmDialog(context, 'Xác nhận đơn hàng đã giao thành công?', 'completed');
        }),
      );
    }
    return const SizedBox.shrink();
  }

  void _confirmDialog(BuildContext context, String title, String nextStatus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận"),
        content: Text(title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Quay lại")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); 
              Navigator.pop(context);
              onUpdateStatus(order, nextStatus); 
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Đồng ý", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildProductItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 70, height: 70,
              child: item.image.isNotEmpty
                  ? Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
                    )
                  : Container(color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 6),
                
                if (item.size.isNotEmpty || item.color.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'Size: ${item.size}  •  Màu: ${item.color}',
                      style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                Text(
                  formatTien(item.price), 
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),

          // 3. SỐ LƯỢNG
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 8),
            child: Text('x${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyRow(String label, double value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(
            formatTien(value), 
            style: TextStyle(
              fontWeight: FontWeight.w500, 
              color: isDiscount ? Colors.green : Colors.black
            )
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, Color textColor, {bool isOutlined = false, required VoidCallback onTap}) {
    return SizedBox(
      height: 50,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ),
    );
  }
  
    Widget _buildSectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14, fontFamily: 'Roboto'),
                children: [
                  TextSpan(text: '$label: ', style: const TextStyle(color: Colors.grey)),
                  TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch(status) {
      case 'pending': color = Colors.orange; text = "Chờ xác nhận"; break;
      case 'confirmed': color = Colors.blue; text = "Đã xác nhận"; break;
      case 'shipping': color = Colors.purple; text = "Đang giao"; break;
      case 'completed': color = Colors.green; text = "Hoàn thành"; break;
      case 'cancelled': color = Colors.red; text = "Đã hủy"; break;
      default: color = Colors.grey; text = "Khác";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}