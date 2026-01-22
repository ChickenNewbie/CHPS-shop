import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Components/trangthaiorder_cpn.dart';

class TrangThaiDonHangScreen extends StatelessWidget {
  const TrangThaiDonHangScreen({super.key, required this.tab});
  final int tab;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: tab + 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Đơn hàng của tôi"),
          bottom: TabBar(
            isScrollable: true, 
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.red,
            tabs: [
              Tab(text: "Tất cả"),
              Tab(text: "Chờ xác nhận"),
              Tab(text: "Chờ vận chuyển"),
              Tab(text: "Đang giao"),
              Tab(text: "Đã giao"),
              Tab(text: "Đã hủy"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderListTab(status: 0),
            OrderListTab(status: 1),
            OrderListTab(status: 2),
            OrderListTab(status: 3),
            OrderListTab(status: 4),
            OrderListTab(status: 5),
          ]
        ),
      ),
    );
  }
}