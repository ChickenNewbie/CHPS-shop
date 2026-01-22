import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/banner.dart';
import 'package:shopgiaydep_flutter/Model/danhmuc.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:shopgiaydep_flutter/Service/banner_api.dart';
import 'package:shopgiaydep_flutter/Service/category_api.dart';
import 'package:shopgiaydep_flutter/Service/product_api.dart';
class HomeScreenProvider extends ChangeNotifier {
  List<BannerModel> _listBanner = []; 
  List<SanPham> _listsp = [];
  List<DanhMuc> _listdm = [];
  List<SanPham> _searchsp = [];
  List<SanPham> _bestsp = [];
  bool _isLoading = false;

  List<BannerModel> get listBanner => _listBanner;
  List<SanPham> get listSP => _listsp;
  List<DanhMuc> get listDM => _listdm;
  List<SanPham> get searchSP => _searchsp;
  List<SanPham> get bestsp => _bestsp;

  bool get isLoading => _isLoading;


  Future<void> fetchDataHome() async {
    _isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        BannerApi.getAllBanner(),
        CategoryAPI.fetchDanhMuc(),
        ProductApi.fetchSanPham(),
        ProductApi.fetchBestSanPham(),
      ]);

      _listBanner = results[0] as List<BannerModel>;
      _listdm = results[1] as List<DanhMuc>;
      _listsp = results[2] as List<SanPham>;
      _bestsp = results[3] as List<SanPham>;
    } catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchResultProduct(String search){
    if(search.isEmpty){
      _searchsp = [];
      notifyListeners();
      return;
    }
    _searchsp = _listsp.where(
      (p) => p.tenSP.toLowerCase().
      contains(search.trim().toLowerCase())
    ).toList();
    notifyListeners();
  }

}

