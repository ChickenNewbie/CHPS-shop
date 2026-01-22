import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/ordercard_cpn.dart';
import 'package:shopgiaydep_flutter/Provider/dathang_provider.dart';
import 'package:shopgiaydep_flutter/Screen/chitietdonhang_screen.dart';

class OrderListTab extends StatefulWidget {
  final int status;
  const OrderListTab({super.key, required this.status});

  @override
  State<OrderListTab> createState() => _OrderListTabState();
}

class _OrderListTabState extends State<OrderListTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders(widget.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    List<dynamic> orders = provider.getOrders(widget.status);
    if (widget.status == 4) {
      orders = orders
          .where((order) =>
            order.items.any((item) => item.daDanhGia == false))
        .toList();
  }
    if (provider.isLoading) return Center(child: CircularProgressIndicator());
    
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/cartempty.jpg", width: 200), 
            const SizedBox(height: 10.0),
            Text("Chưa có đơn hàng nào, hãy tiếp tục mua sắm"),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final currentOrder = orders[index];
        return OrderCard(
          key: ValueKey(currentOrder.maHD),
          order: currentOrder, 
          onReload: () {
             context.read<OrderProvider>().fetchOrders(widget.status);
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderDetailScreen(order: currentOrder),
              ),
            );
          },
        );
      },
    );
  }
}