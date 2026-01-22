import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:shopgiaydep_flutter/Service/product_api.dart';
class DanhMucProvider extends ChangeNotifier {
  List<SanPham> _listdmsp = [];
  bool _isLoading = false;

  List<SanPham> get listSP => _listdmsp;
  bool get isLoading => _isLoading;


  Future<void> fetchDataCategories(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _listdmsp = await ProductApi.fetchDanhMucSanPham(id);
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

