import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/giohang.dart';
import 'package:shopgiaydep_flutter/Model/orderItem.dart';
import 'package:shopgiaydep_flutter/Service/cart_api.dart';

class GioHangProvider extends ChangeNotifier {
  GioHang? _cart;
  bool _isLoading = false;

  GioHang? get cart => _cart;
  bool get isLoading => _isLoading;
  
  int get totalItems{
    if(_cart == null) return 0;
    return _cart!.items.fold(0,(sum, item) => sum + item.soLuong);
  }
  double get total {
    if (_cart == null) return 0.0;
    return _cart!.items
    .where((item) => item.isSelected)
    .fold(0, (sum, item) => sum + (item.donGia * item.soLuong));
  }

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cart = await CartApi.getAllCart();
    } catch (e) {
      debugPrint("Lỗi nạp giỏ hàng: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(int maCTSP, int soLuong) async {
    bool success = await CartApi.addToCarrt(maCTSP, soLuong);
    if (success) {
      await fetchCart(); 
    }
    return success;
  }

 Future<void> updateQuantity(int maGH, int maCTSP, int soLuong) async {
    if (_cart == null) return;
    final index = _cart!.items.indexWhere((element) => element.maCTSP == maCTSP);
    
    if (index != -1) {
      final item = _cart!.items[index]; 
      int sl = item.soLuong + soLuong;
      if (sl < 1) return;

      try {
        bool success = await CartApi.updateItem(maGH, maCTSP, sl);
        if (success) {
          _cart!.items[index].soLuong = sl;
          notifyListeners(); 
        }
      } catch (e) {
        debugPrint("Lỗi cập nhật số lượng: $e");
      }
    }

  }

  Future<void> removeItem(int maGH, int maCTSP) async {
    debugPrint("DEBUG: Đang xoá - MaGH: $maGH, MaCTSP: $maCTSP");
    if (_cart == null) return;
    final index = _cart!.items.indexWhere((element) => element.maCTSP == maCTSP);
    if (index != -1) {
      try {
        bool success = await CartApi.removeItem(maGH, maCTSP);
        if (success) {
          debugPrint("Xoá thành công trên server");
          _cart!.items.removeAt(index);
          notifyListeners(); 
        }else{
          debugPrint("Xoá thất bại trên server");
        }
      } catch (e) {
        debugPrint("Lỗi xoá sản phẩm: $e");
      }
    }
  }

  void isChecked(int MaCTSP){
    if(_cart == null) return;
    final index = _cart!.items.indexWhere(
      (e) => e.maCTSP == MaCTSP,
    );
    if(index != -1){
      _cart!.items[index].isSelected = !cart!.items[index].isSelected;
      notifyListeners();
    }
  }

  void clearLocalCart() {
    if (_cart != null) {
     _cart!.items.removeWhere((item) => item.isSelected == true);
      notifyListeners();
      debugPrint("Đã làm rỗng giỏ hàng cục bộ.");
    }
  }

  void resetCart() {
    _cart = null; 
    notifyListeners(); 
    debugPrint("Giỏ hàng đã được reset hoàn toàn.");
  }




  Future<void> muaLaiDonHang(List<OrderItem> items) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait(items.map((item) async {
        try {
          await CartApi.addToCarrt(item.maCTSP, item.soLuong);
        } catch (e) {
          debugPrint("Lỗi thêm sp ${item.maCTSP}: $e");
        }
      }));

      await fetchCart();
      
    } catch (e) {
      debugPrint("Lỗi mua lại đơn hàng: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
