import 'package:intl/intl.dart';

String formatTien(num tien) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );
  return formatter.format(tien);
}
