import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/danhgia_cpn.dart';
import 'package:shopgiaydep_flutter/Provider/danhgiasanpham_provider.dart';

class DanhGia extends StatefulWidget{
  const DanhGia({super.key, required this.id});
  final int id;
  @override
  State<DanhGia> createState() => _DanhGiaState();
}

class _DanhGiaState extends State<DanhGia>{
  @override
  void initState(){
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<DanhGiaProvider>().fetchReviewAll(widget.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tất cả đánh giá'),
        centerTitle: true,
      ),
      body: Consumer<DanhGiaProvider>(
        builder: (context, provider, child){
          if(provider.loading){
            return const Center(child: CircularProgressIndicator());
          }
          final reviews = provider.danhGia;
          if (reviews == null || reviews.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('Sản phẩm này chưa có đánh giá')),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(), 
            itemCount: reviews.length,
            itemBuilder: (context, index){
            final review = reviews[index];
              return DanhGiaItem(item: review);
            }, 
          );
        }
      )
    );
  }
}