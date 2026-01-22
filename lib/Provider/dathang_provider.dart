import 'package:shopgiaydep_flutter/Model/order.dart';
import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Service/order_api.dart';
class OrderProvider extends ChangeNotifier {
  Map<int, List<Order>> _ordersByStatus = {};
  bool _isLoading = false;

  List<Order> getOrders(int status) => (_ordersByStatus[status] ?? []).toList();
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(int statusId) async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Order> data = await OrderApi.getOrderByStatus(statusId);
      _ordersByStatus[statusId] = data;
    } catch (e) {
      debugPrint("Lỗi load đơn hàng: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
  
  Future<bool> cancelOrder(int maHD) async {
    try {
      bool success = await OrderApi.cancelOrder(maHD);
      if (success) {
        removeOrderLocal(maHD);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } 
  }
  void removeOrderLocal(int maHD) {
    _ordersByStatus.forEach((statusId, list) {
      list.removeWhere((item) => item.maHD == maHD);
    });
    notifyListeners(); 
  }
  
  void clearOrders() {
    _ordersByStatus.clear();
    notifyListeners();
  }

  int getSoLuongByStatus(int status) {
    if (!_ordersByStatus.containsKey(status)) return 0;
    if (status == 4) {
      int count = 0;
      for (var order in _ordersByStatus[status]!) {
        count += order.items.where((item) => item.daDanhGia == false).length;
      }
      return count;
    }
    return _ordersByStatus[status]!.length;
  }

  void updateReviewStatusLocal(int maCTSP) {
    _ordersByStatus.forEach((status, orders) {
      for (var order in orders) {
        for (var item in order.items) {
          if (item.maCTSP == maCTSP) {
            item.daDanhGia = true;
          }
        }
      }
    });
    notifyListeners(); 
  }
}

