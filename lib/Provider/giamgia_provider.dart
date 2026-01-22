import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/giamgia.dart';
import 'package:shopgiaydep_flutter/Service/giamgia_api.dart';

class GiamgiaProvider extends ChangeNotifier{
  List<GiamGia> _listGiamGia = [];
  GiamGia? _voucherDuocChon;
  bool _isLoading = false;

  List<GiamGia> get dsGiamGia => _listGiamGia;
  GiamGia? get voucherDuocChon => _voucherDuocChon;
  bool get loading => _isLoading;

  Future<void> fetchVouchers()async{
    _isLoading = true;
    notifyListeners();
    try{
      _listGiamGia = await GiamGiaApi.getAllVouchers();
    }catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void chonVoucher(GiamGia vch) {
    _voucherDuocChon = vch;
    notifyListeners();
  }

  void huyChonVoucher() {
    _voucherDuocChon = null;
    notifyListeners();
  }
  double tinhSoTienGiam(double tongTien){
    if(_voucherDuocChon == null || tongTien < _voucherDuocChon!.donHangToiThieu){
      return 0.0;
    }
    double ketquaGiam = 0.0;
    if(_voucherDuocChon!.giaTriGiam <= 100){
      ketquaGiam = tongTien * (_voucherDuocChon!.giaTriGiam/100);
    }else{
      ketquaGiam = _voucherDuocChon!.giaTriGiam.toDouble();
    }
    
    if(ketquaGiam > _voucherDuocChon!.giamToiDa){
      ketquaGiam = _voucherDuocChon!.giamToiDa;
    }
    return ketquaGiam;
  }
}