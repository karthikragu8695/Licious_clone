class Product {
  final int id;
  final String name;
  final String image;
  final String weight;
  final String pieces;
  final int price;
  final int oldprice;
  final int discount;
  final int category;
  final int deliveryMinutes;
  final bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.weight,
    required this.pieces,
    required this.price,
    required this.oldprice,
    required this.discount,
    required this.category,
    required this.deliveryMinutes,
    required this.isBestSeller,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      weight: json['weight'] ?? '',
      pieces: json['pieces'] ?? '',
      price: json['price'] ?? 0,
      oldprice: json['oldprice'] ?? 0,
      discount:json['discount'] ?? 0,
     category:json['category'] ?? 0,
      deliveryMinutes:json['deliveryMinutes'] ?? 0,
      isBestSeller:json['isBestSeller'] ?? false
    );
  }
}
