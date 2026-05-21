class Category {

  final String title;
  final String image;
  final String product;
  final String key;
  final int id;

  Category({
    required this.id,
    required this.key,
    required this.title,
    required this.image,
    required this.product,
  });

  factory Category.fromJson(
      Map<String, dynamic> json) {

    return Category(

      id: json['id'] ?? 0,

      key: json['key']?? "",

      title: json['title'] ?? "",

      image: json['image'] ?? "",

      product: json['product'] ?? "",
    );
  }
}