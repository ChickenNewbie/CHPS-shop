import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/diachi.dart';
import 'package:shopgiaydep_flutter/Service/address_api.dart';

class  DiachiProvider extends ChangeNotifier{
  List<DiaChi>? _diaChi;
  DiaChi? _diaChidc;
  bool _isLoading = false;
  double _phiship = 0.0;
  int _maPVC = 1;

  List<DiaChi>? get diaChi => _diaChi;
  DiaChi? get selectedAddress => _diaChidc;
  bool get isLoading => _isLoading;
  double get phiShip => _phiship;
  int get maPVC => _maPVC;

  Future<void> fetchAddress()async{
    _isLoading = true;
    notifyListeners();
    try{
      _diaChi = await AddressApi.getAllAddress();
      if(_diaChi != null && _diaChi!.isNotEmpty){
        _diaChidc = _diaChi!.firstWhere(
          (e) => e.laMacDinh == 1 || e.laMacDinh == true,
          orElse: () => _diaChi![0]
        );
      }
      fetchPhiVanChuyen();
    }catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void capNhatDiaChiDuocChon(DiaChi dc){
    _diaChidc = dc;
    debugPrint(dc.diaChiChiTiet);
    fetchPhiVanChuyen();
    debugPrint(_phiship.toString());

    notifyListeners();
  }

  Future<void> themDiaChiMoi(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final DiaChi? dc = await AddressApi.addAddress(data);
      if (dc == null) return;

      _diaChi ??= [];
      if (dc.laMacDinh == true) {
        _diaChi = _diaChi!
            .map((item) => item.copyWith(laMacDinh: false))
            .toList();
      }

      _diaChi!.insert(0, dc);
      _diaChidc = dc;
      fetchPhiVanChuyen();
    } catch (e) {
      debugPrint("Lỗi thêm địa chỉ: $e");
      rethrow; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> capNhatDiaChi(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final DiaChi? updated = await AddressApi.updateAddress(id, data);
      if (updated == null) return;

      if (_diaChi != null) {
        _diaChi = _diaChi!.map((item) {
          if (item.maDC == id) return updated;
          if (updated.laMacDinh == true) {
            return item.copyWith(laMacDinh: false);
          }
          return item;
        }).toList();
      }
      if (_diaChidc?.maDC == id) {
        _diaChidc = updated;
        fetchPhiVanChuyen();
      }
      
    } catch (e) {
      debugPrint("Lỗi cập nhật địa chỉ: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> xoaDiaChi(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final success = await AddressApi.deleteAddress(id);
      if (!success) return;

      _diaChi?.removeWhere((item) => item.maDC == id);

      if (_diaChidc?.maDC == id) {
        _diaChidc = _diaChi?.isNotEmpty == true ? _diaChi!.first : null;
      }

      if (_diaChidc != null) {
        fetchPhiVanChuyen();
      }
    } catch (e) {
      debugPrint("Lỗi xoá địa chỉ: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }




  void fetchPhiVanChuyen()async{
    if(_diaChidc == null) return;
    try {
      final result = await AddressApi.getPriceByAddress(_diaChidc!.diaChiChiTiet);
      _phiship = result['phivanchuyen'].toDouble();
      _maPVC = result['maPVC'];
      notifyListeners();
    } catch (e) {
      debugPrint("Lỗi tải bảng phí ship: $e");
      _phiship = 55000; 
      notifyListeners();
    }
  }
  


}