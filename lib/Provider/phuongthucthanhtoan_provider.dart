import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/phuongthucthanhtoan.dart';
import 'package:shopgiaydep_flutter/Service/phuongthucthanhtoan_api.dart';

class PhuongThucThanhToanProvider extends ChangeNotifier{
  List<PhuongThucThanhToan> _dspttt = [];
  bool _isLoading = false;
  PhuongThucThanhToan? _pttt;

  List<PhuongThucThanhToan> get dsPTTT => _dspttt;
  PhuongThucThanhToan? get selectedPTTT => _pttt;
  bool get isLoading => _isLoading;

  Future<void> fetchPhuongThucTT()async{
    _isLoading = true;
    notifyListeners();
    try{
      _dspttt = await PhuongThucThanhToanApi.getAllPayment();
      if(_dspttt.isNotEmpty && _pttt == null){
        _pttt = _dspttt[0];
      }
    }catch (e) {
      debugPrint("Lỗi tải PTTT: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void CapNhatPTTT(PhuongThucThanhToan pttt) {
    _pttt = pttt;
    notifyListeners();
  }
}