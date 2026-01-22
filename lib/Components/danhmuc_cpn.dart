import 'package:flutter/material.dart';

class DanhMucItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const DanhMucItem({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover, // 🔥 QUAN TRỌNG
              ),
            ),
          ),
        ],
      ),
    );
  }
}
