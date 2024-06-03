class CategoryList {
  final String name;
  final String imagePath;

  CategoryList({required this.name, required this.imagePath});
}

List<CategoryList> categories = [
  CategoryList(name: 'logo design', imagePath: 'assets/images/logoDesigne.jpg'),
  CategoryList(name: 'Ai', imagePath: 'assets/images/ia.jpg'),
  CategoryList(name: 'app design', imagePath: 'assets/images/appdevvv.jpg'),
];
