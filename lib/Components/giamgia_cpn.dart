import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Model/giamgia.dart';

class GiamGiaWidget extends StatelessWidget{
  const GiamGiaWidget({
    super.key, 
    required this.voucher,
    required this.isChon,
    required this.onTap
  });
  final GiamGia voucher;
  final bool isChon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    bool freeShip = voucher.maVoucher.toLowerCase()
    .contains('freeship');
    Color color = isChon ? Colors.teal : Colors.pinkAccent;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isChon ? color.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isChon ? color : Colors.grey.shade200,
            width: isChon ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                freeShip ? Icons.local_shipping : Icons.local_offer,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.tenVoucher,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    voucher.giaTriGiam <= 100
                        ? "Giảm ${voucher.giaTriGiam}% đơn từ ${formatTien(voucher.donHangToiThieu)}"
                        : "Giảm ${formatTien(voucher.giaTriGiam.toDouble())} đơn từ ${formatTien(voucher.donHangToiThieu)}",
                    style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "HSD: ${DateFormat('dd/MM/yyyy').format(voucher.ngayKetThuc)}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(
              isChon ? Icons.check_circle : Icons.radio_button_off,
              color: isChon ? color : Colors.grey.shade300,
            ),
          ],
        ),
      ),

    );
  }
}
