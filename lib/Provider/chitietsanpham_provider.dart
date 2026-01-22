import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/chitietsanpham.dart';
import 'package:shopgiaydep_flutter/Service/product_api.dart';

class ChiTietSanPhamProvider extends ChangeNotifier {
  ChiTietSanPham? _chiTietSanPham;
  bool _isLoading = false;
  ChiTietSanPham? get chitietsp => _chiTietSanPham;
  bool get isLoading => _isLoading;

  Future<void> fetchChiTietSanPham(int id)async{
    _isLoading = true;
    notifyListeners();
    try{
      _chiTietSanPham = await ProductApi.getProductDetail(id);
    }catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}