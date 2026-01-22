import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/cartitem_cpn.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Screen/thanhtoan_screen.dart';


class GioHangScreen extends StatefulWidget{
  const GioHangScreen({super.key});
  @override
  State<GioHangScreen> createState() => _GioHangScreenState();
}

class _GioHangScreenState extends State<GioHangScreen>{
  static const bgColor = Colors.white; 
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<GioHangProvider>().fetchCart();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Giỏ hàng của tôi',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
        centerTitle: true,
      ),
      body: Consumer<GioHangProvider>(
        builder: (context, provider, child){
           if(provider.isLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if(provider.cart == null){
            return const Center(child: Text('Chưa có sản phẩm nào trong giỏ'));
          }
          if(provider.cart!.items.isEmpty){
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Chưa có sản phẩm nào trong giỏ'),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, 
                  child: Text('Tiếp tục mua sắm'))
                ],
              ),
            );
          }
          final cart = provider.cart!;
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index){
              final item = cart.items;
              return CartItemWidget(item: item[index]);
            }
          );
        }
      ),
      bottomNavigationBar: Consumer<GioHangProvider>(
        builder: (context, provider, child){
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tổng thanh toán:",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      formatTien(provider.total),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ]
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: provider.total > 0 ? () {
                      final danhSachsp = provider.cart!.items.where(
                        (item) => item.isSelected
                      ).toList();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ThanhtoanScreen(danhSachChon: danhSachsp, tongTien: provider.total))
                      );
                    } : null, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "THANH TOÁN",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }
}