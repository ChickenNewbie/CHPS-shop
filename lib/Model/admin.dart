class Order {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final DateTime orderDate;
  final double totalAmount;
  final double shipping;
  final String status;
  final String? voucherCode;
  final double discount;
  final List<OrderItem> items;


  Order({
    required this.id, 
    required this.customerName, 
    required this.customerPhone,
    required this.address, 
    required this.orderDate, 
    required this.totalAmount,
    required this.shipping,
    required this.status, 
    required this.items, 
    this.voucherCode, 
    this.discount = 0.0,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '', 
      customerName: json['customerName'] ?? 'Khách lẻ',
      customerPhone: json['customerPhone'] ?? '',
      address: json['address'] ?? '',
      

      orderDate: DateTime.tryParse(json['orderDate']?.toString() ?? '') ?? DateTime.now(),

      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      shipping: (json['shippingFee']as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'unknown',
      voucherCode: json['voucherCode'],
      

      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      

      items: (json['items'] as List<dynamic>?)
          ?.map((i) => OrderItem.fromJson(i))
          .toList() ?? [],
          
    );
  }
}

class OrderItem {
  final String productName;
  final int quantity;
  final double price;
  final String image; 
  final String size;  
  final String color; 

  OrderItem({
    required this.productName, 
    required this.quantity, 
    required this.price, 
    this.image = '', 
    this.size = '', 
    this.color = ''
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? 'Sản phẩm',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      size: json['size'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

