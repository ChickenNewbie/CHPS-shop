import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/giamgia_cpn.dart';
import 'package:shopgiaydep_flutter/Provider/giamgia_provider.dart';

class DanhSachVoucher extends StatefulWidget {
  const DanhSachVoucher({super.key, this.isChonVoucher = true});
  final bool isChonVoucher;

  @override
  State<DanhSachVoucher> createState() => _DanhachVoucherState();
}

class _DanhachVoucherState extends State<DanhSachVoucher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GiamgiaProvider>(context, listen: false).fetchVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.isChonVoucher;
    return Scaffold(
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        title: const Text(
          "Danh sách voucher",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Consumer<GiamgiaProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
          }
          if (provider.dsGiamGia.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_number_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("Hiện chưa có mã giảm giá nào", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: provider.dsGiamGia.length,
            itemBuilder: (context, index) {
              final item = provider.dsGiamGia[index];
              return GiamGiaWidget(
                voucher: item,
                isChon: selected 
                ? provider.voucherDuocChon?.maVoucher == item.maVoucher
                : false,
                onTap: () {
                  if(selected){
                    provider.chonVoucher(item);
                    Navigator.pop(context);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}