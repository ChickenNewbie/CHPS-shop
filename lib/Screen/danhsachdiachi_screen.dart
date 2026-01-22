import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Provider/diachi_provider.dart';
import 'package:shopgiaydep_flutter/Screen/diachifrm_screen.dart';

class DanhsachdiachiScreen extends StatelessWidget {
  const DanhsachdiachiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Chọn địa chỉ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<DiachiProvider>(
        builder: (context, provider, child) {
          final list = provider.diaChi ?? [];
          return Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: list.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = list[index];
                  return InkWell(
                    onTap: () {
                      provider.capNhatDiaChiDuocChon(item);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.tenNguoiNhan,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "(+84) ${item.sdt}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Text(item.diaChiChiTiet),
                                Text(
                                  "Việt Nam",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                if (item.laMacDinh == true)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      border: Border.all(color: Colors.red.shade200),
                                    ),
                                    child: const Text(
                                      "Mặc định",
                                      style: TextStyle(color: Colors.red, fontSize: 11),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ThemDiaChiScreen(adrressEdit: item)));
                            }, 
                            child: Text('Chỉnh sửa', style: TextStyle(color: Colors.red),))
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF2D55), 
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ThemDiaChiScreen()),
                      );
                    },
                    child: const Text(
                      "Thêm địa chỉ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}