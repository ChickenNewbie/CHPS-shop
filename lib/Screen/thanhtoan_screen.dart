import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Components/dinhdang_cpn.dart';
import 'package:shopgiaydep_flutter/Model/cartitem.dart';
import 'package:shopgiaydep_flutter/Model/diachi.dart';
import 'package:shopgiaydep_flutter/Provider/diachi_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giamgia_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/phuongthucthanhtoan_provider.dart';
import 'package:shopgiaydep_flutter/Screen/canhan_screen.dart';
import 'package:shopgiaydep_flutter/Screen/danhsachdiachi_screen.dart';
import 'package:shopgiaydep_flutter/Screen/danhsachvoucher.dart';
import 'package:shopgiaydep_flutter/Screen/diachifrm_screen.dart';
import 'package:shopgiaydep_flutter/Service/thanhtoan_api.dart';

class ThanhtoanScreen extends StatefulWidget {
  const ThanhtoanScreen({
    super.key,
    required this.danhSachChon,
    required this.tongTien,
  });

  final List<CartItem> danhSachChon;
  final double tongTien;

  @override
  State<ThanhtoanScreen> createState() => _ThanhtoanScreenState();
}

class _ThanhtoanScreenState extends State<ThanhtoanScreen> {
  static const bgColor = Colors.white;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DiachiProvider>(context, listen: false).fetchAddress();
      Provider.of<PhuongThucThanhToanProvider>(context, listen: false).fetchPhuongThucTT();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Tóm tắt yêu cầu thanh toán"),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<DiachiProvider>(
              builder: (context, provider, _) {
                return _builDiaChiGiaoHang(context, provider);
              },
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.danhSachChon.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = widget.danhSachChon[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(item.hinhAnh, width: 50),
                    ),
                    title: Text(item.tenSP),
                    subtitle: Text(
                      "SL: ${item.soLuong} | Size: ${item.tenSize} | Màu: ${item.mauSac}",
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing:
                        Text(formatTien(item.donGia * item.soLuong)),
                  ),
                );
              },
            ),
             Consumer<GiamgiaProvider>(
              builder: (context, provider, _) {
                return _buildVoucher(context, provider);
              },
            ),
            _buildTomTatThanhToan(),
            _buildPhuongThucThanhToan(context)
            
          ],
        ),
      ),
      bottomNavigationBar:  Consumer3<GiamgiaProvider, DiachiProvider, PhuongThucThanhToanProvider>(
        builder: (context, vchProv, addrProv, payProv, child) {
        double tienHang = widget.tongTien;
        double phiShip = addrProv.phiShip;
        double tienGiam = vchProv.tinhSoTienGiam(tienHang);
        double tongCuoi = (tienHang + phiShip) - tienGiam;
        int soLuong = widget.danhSachChon.length;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tổng($soLuong sản phẩm)", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text(
                    formatTien(tongCuoi),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _datHang();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Đặt hàng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    ),
    );
  }
  Widget _buildVoucher(BuildContext context, GiamgiaProvider provider){
    final voucherDc = provider.voucherDuocChon;
    double soTienGiam = provider.tinhSoTienGiam(widget.tongTien);
    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => const FractionallySizedBox(
            heightFactor: 0.6,
            child: DanhSachVoucher(),
          ),
        ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            const Icon(Icons.confirmation_number_outlined, color: Colors.pink, size: 20),
            const SizedBox(width: 8),
            const Text(
              "Giảm giá từ CHPS Shop",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Spacer(),
            if(voucherDc != null)...[
              Column(
                children: [
                  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:  Text(voucherDc.tenVoucher, 
                    style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(width: 8.0),
              Text(
                "- ${formatTien(soTienGiam)}",
                style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
              ),
                ],
              ) 
            ],
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  Widget _builDiaChiGiaoHang(
    BuildContext context, DiachiProvider provider) {
    final dc = provider.selectedAddress;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (dc != null) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const FractionallySizedBox(
              heightFactor: 0.6,
              child: DanhsachdiachiScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ThemDiaChiScreen()),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: dc != null ? _buildThongTinDiaChi(dc) : _builFormDiaChi(),
        ),
      ),
    );
  }

  Widget _buildThongTinDiaChi(DiaChi dc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${dc.tenNguoiNhan} | ${dc.sdt}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          dc.diaChiChiTiet,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        if (dc.laMacDinh)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Mặc định",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _builFormDiaChi() {
    return Row(
      children: const [
        Icon(Icons.add_location_alt, color: Colors.red),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm địa chỉ giao hàng",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Thêm địa chỉ để xem phí vận chuyển",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right),
      ],
    );
  }
  Widget _buildTomTatThanhToan() {
    return Consumer2<GiamgiaProvider, DiachiProvider>(
      builder: (context, provider, dcProvider, child) {
        double tienHang = widget.tongTien;
        double tienGiam = provider.tinhSoTienGiam(tienHang);
        double phiVanChuyen = dcProvider.phiShip; 
        double tongThanhToan = (tienHang + phiVanChuyen) - tienGiam;

        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Tóm tắt yêu cầu", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              _buildTongTien("Tổng phụ sản phẩm", formatTien(tienHang-tienGiam)),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Column(
                  children: [
                    _buildGiamGia("Giá gốc", formatTien(tienHang)),
                    _buildGiamGia("Voucher CHSP shop", formatTien(tienGiam), color: Colors.redAccent, char: '-') 
                  ],
                )
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng phụ vận chuyển", style: TextStyle(color: Colors.black87)),
                  Text(formatTien(phiVanChuyen ), 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: _buildGiamGia("Phí vận chuyển", formatTien(phiVanChuyen), color: Colors.redAccent, char: '+') 
                ),
              
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(thickness: 0.5),
              ),

              // Tổng cuối cùng của phần tóm tắt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tổng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(formatTien(tongThanhToan), 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildTongTien(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Colors.black87)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}

  Widget _buildGiamGia(String label, String value, {Color? color, String? char}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text( char != null 
          ?  '$char $value' : value
          , style: TextStyle(color: color ?? Colors.black87, fontSize: 13)
        ),
      ],
    ),
  );
}

  Widget _buildPhuongThucThanhToan(BuildContext context) {
  return Consumer<PhuongThucThanhToanProvider>(
    builder: (context, provider, child) {
      final ptttSelected = provider.selectedPTTT;
      return InkWell(
        onTap: () => _showPhuongThucThanhToanBottomSheet(context, provider), 
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Phương thức thanh toán",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (ptttSelected != null) ...[
                    Image.network(ptttSelected.hinhAnh, width: 30, height: 30),
                    const SizedBox(width: 12),
                    Text(ptttSelected.tenPT, style: const TextStyle(fontSize: 15)),
                  ] else
                    const Text("Chọn phương thức thanh toán"),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

 void _showPhuongThucThanhToanBottomSheet(BuildContext context, PhuongThucThanhToanProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Chọn phương thức thanh toán",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              ...provider.dsPTTT.map((item) {
                bool isSelected = provider.selectedPTTT?.maPT == item.maPT;
                return ListTile(
                  leading: Image.network(item.hinhAnh, width: 35),
                  title: Text(item.tenPT),
                  trailing: isSelected 
                      ? const Icon(Icons.check_circle, color: Colors.pink) 
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    provider.CapNhatPTTT(item);
                    Navigator.pop(context); 
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
 void _datHang() async {
    final addrProv = Provider.of<DiachiProvider>(context, listen: false);
    final vchProv = Provider.of<GiamgiaProvider>(context, listen: false);
    final payProv = Provider.of<PhuongThucThanhToanProvider>(context, listen: false);
    final cartProv = Provider.of<GioHangProvider>(context, listen: false);

    if (addrProv.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn địa chỉ giao hàng!")),
      );
      return;
    }
    double tienHang = widget.tongTien;
    double phiShip = addrProv.phiShip;
    double giamGia = vchProv.tinhSoTienGiam(tienHang);
    double tongCuoi = (tienHang + phiShip) - giamGia;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.pink)),
    );

    try {
      int? maHD = await ThanhToanApi.ThanhToan(
        items: widget.danhSachChon,
        maVoucher: vchProv.voucherDuocChon?.maVoucher,
        maPVC: addrProv.maPVC,
        maPT: payProv.selectedPTTT?.maPT ?? 1,
        diaChi: addrProv.selectedAddress!.diaChiChiTiet,
        sdt: addrProv.selectedAddress!.sdt,
        tenNguoiNhan: addrProv.selectedAddress!.tenNguoiNhan,
        giaShip: phiShip,
        tongGiamGia: giamGia,
        tongTienCuoi: tongCuoi,
      );
      if (mounted) Navigator.pop(context);

      if (maHD != null) {
        cartProv.clearLocalCart();
        _showSuccessDialog(maHD);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đặt hàng thất bại. Vui lòng thử lại!")),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      debugPrint("Lỗi đặt hàng: $e");
    }
  }
 void _showSuccessDialog(int maHD) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text("Thành công!"),
          ],
        ),
        content: Text("Đơn hàng #$maHD đã được đặt thành công. Cảm ơn bạn đã mua sắm!"),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                Navigator.pop(context); 
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: const Text("Xem đơn hàng", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

}
