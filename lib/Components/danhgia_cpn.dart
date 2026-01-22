import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/danhgia.dart';

class DanhGiaItem extends StatelessWidget {
  const DanhGiaItem({super.key, required this.item});
  final DanhGia item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, size: 20, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.username, 
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 12,
                          color: index < item.soSao ? Colors.amber : Colors.grey[300],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          Text(
            "Phân loại: ${item.mauSac}, Size ${item.tenSize}",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),

          const SizedBox(height: 6),

          Text(
            item.noiDung,
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),

          if (item.hinhAnhDG != null && item.hinhAnhDG!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), 
                  child: Image.network(
                    item.hinhAnhDG!,
                    width: 120, 
                    height: 120,
                    fit: BoxFit.cover,
                    
                  ),
                ),
              ),
            ),

          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Text(
                "${item.ngayDanhGia.day.toString().padLeft(2, '0')}/${item.ngayDanhGia.month.toString().padLeft(2, '0')}/${item.ngayDanhGia.year}",
                style: TextStyle(
                  color: Colors.grey[500], 
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}