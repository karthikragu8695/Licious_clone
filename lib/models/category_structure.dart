class Category {
  final String title;
  final String image;
  final String key; 
  final String product;
  Category({required this.title, required this.image,required this.key,required this.product});
}

List<Category> categories = [
  Category(title: 'Chicken', image: 'assets/images/CHICKEN1.jpg',key: "Chicken",product: 'Chicken'),
  Category(title: 'Mutton', image: 'assets/images/muttonCate.png',key: "Mutton",product: 'Mutton'),
  Category(title: 'SeaWaterFish', image: 'assets/images/seawaterfish.png',key: "SeaWaterFish",product: 'SeaWaterFish'),
  Category(title: 'Freshwater\nFish', image: 'assets/images/FISH.jpg',key: "Freshwater\nFish",product: 'Freshwater\nFish'),
  Category(title: 'Eggs', image: 'assets/images/eggscate.webp',key: "Eggs",product: 'Eggs'),
  Category(title: 'Crispies & Wings', image: 'assets/images/crispy.png',key: "Crispies & Wings",product: 'Crispies & Wings'),
  Category(title: 'Ready to\n cook', image: 'assets/images/readytocook.png',key: "Ready to\n cook",product: 'Ready to\n cook'),
  Category(title: 'Prawns &\n Crabs', image: 'assets/images/prawns.png',key: "Prawns &\n Crabs",product: 'Prawns &\n Crabs'),
  Category(title: 'Spreads &\nCold cuts', image: 'assets/images/coldCuts.png',key: "Spreads &\nCold cuts",product: 'Spreads &\nCold cuts'),
  Category(title: 'Masala', image: 'assets/images/masala.webp',key: "Masala",product: 'Masala'),
  Category(title: 'Liver & \nMore', image: 'assets/images/liver.webp',key: "Liver & \nMore",product: 'Liver & \nMore'),
  Category(title: 'Combos', image: 'assets/images/combos.png',key: "Combos",product: 'Combos'),
];
