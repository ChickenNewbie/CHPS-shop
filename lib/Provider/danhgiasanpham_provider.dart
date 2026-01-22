import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Model/danhgia.dart';
import 'package:shopgiaydep_flutter/Service/danhgia_api.dart';

class DanhGiaProvider extends ChangeNotifier{
  List<DanhGia>? _danhGia;
  bool _isLoading = false;

  List<DanhGia>? get danhGia => _danhGia;
  bool get loading => _isLoading;

  Future<void> fetchReviewAll(int id)async{
    _isLoading = true;
    notifyListeners();
    try{
      _danhGia = await DanhgiaApi.getReviewsById(id);
    }catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReviewLimit(int id)async{
    _isLoading = true;
    notifyListeners();
    try{
      _danhGia = await DanhgiaApi.getReviewsByIdLimit(id);
    }catch (e) {
      debugPrint("Lỗi tải dữ liệu: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addReview(int maCTSP, double soSao, String noiDung, int maSP, int maCTHD, File? image,) async {
    _isLoading = true;
    notifyListeners();

    bool success = await DanhgiaApi.addReview(
      maCTSP: maCTSP,
      soSao: soSao,
      noiDung: noiDung,
      maCTHD: maCTHD,
      image: image,
    );
    debugPrint('Success: $success');
    if (success) {
      await fetchReviewAll(maSP); 
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}