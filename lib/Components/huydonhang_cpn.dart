import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Components/confirmdialog_cpn.dart';
import 'package:shopgiaydep_flutter/Service/order_api.dart';

void cancelOrder(BuildContext context, int maHD)async{
    bool confirm =  await ConfirmDialog.show(
          context: context,
          title: const Text("Xác nhận"),
          content: const Text("Bạn có chắc chắn muốn huỷ đơn này?"),
          confirmButtonText: "Đồng ý",
          cancelButtonText: "Hủy",
    );
    if(confirm){
      bool success = await OrderApi.cancelOrder(maHD);
      if(success){
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hủy đơn hàng thành công")),
          );
        }
      }else{
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hủy đơn hàng thất bại")),
          );
        }
      }
    }
  }
  
 