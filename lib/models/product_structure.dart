class Product {
  final int id;
  final String name;
  final String image;
  final String weight;
  final String pieces;
  final double price;
  final double oldprice;
  final int discount;
  final String category;
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
}
