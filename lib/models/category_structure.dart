class Category {
  final String title;
  final String image;
  final String key; 
  final String product;
  Category({required this.title, required this.image,required this.key,required this.product});
}

List<Category> categories = [
  Category(title: 'Chicken', image: 'assets/images/CHICKEN1.jpg',key: "1",product: 'Chicken'),
  Category(title: 'Mutton', image: 'assets/images/muttonCate.png',key: "2   ",product: 'Mutton'),
  Category(title: 'SeaWaterFish', image: 'assets/images/seawaterfish.png',key: "3",product: 'SeaWaterFish'),
  Category(title: 'Freshwater Fish', image: 'assets/images/FISH.jpg',key: "4",product: 'Freshwater Fish'),
  Category(title: 'Eggs', image: 'assets/images/eggscate.webp',key: "Eggs",product: 'Eggs'),
  Category(title: 'Crispies & Wings', image: 'assets/images/crispy.png',key: "Crispies & Wings",product: 'Crispies & Wings'),
  Category(title: 'Ready to cook', image: 'assets/images/readytocook.png',key: "Ready to cook",product: 'Ready to cook'),
  Category(title: 'Prawns &  Crabs', image: 'assets/images/prawns.png',key: "Prawns & Crabs",product: 'Prawns & Crabs'),
  Category(title: 'Spreads & Cold cuts', image: 'assets/images/coldCuts.png',key: "Spreads & Cold cuts",product: 'Spreads & Cold cuts'),
  Category(title: 'Masala', image: 'assets/images/masala.webp',key: "Masala",product: 'Masala'),
  Category(title: 'Liver & More', image: 'assets/images/liver.webp',key: "Liver & More",product: 'Liver & More'),
  Category(title: 'Combos', image: 'assets/images/combos.png',key: "Combos",product: 'Combos'),
];
