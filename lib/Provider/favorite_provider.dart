import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/sanpham.dart';
import 'package:shopgiaydep_flutter/Service/favorite_api.dart';

class FavoriteProvider extends ChangeNotifier {
  List<SanPham> _favorites = [];


  List<SanPham> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await FavoriteApi.fetchSanPhamYeuThich();
    notifyListeners();
  }


  Future<void> handleFavorite(int maSP) async {
    bool isNowFavorite = await FavoriteApi.themXoaFavorite(maSP);
    
    if (isNowFavorite) {
      await loadFavorites(); 
    } else {
      _favorites.removeWhere((item) => item.maSP == maSP);
    }

    notifyListeners(); 
  }

  bool isExist(int maSP) {
    return _favorites.any((item) => item.maSP == maSP);
  }

}