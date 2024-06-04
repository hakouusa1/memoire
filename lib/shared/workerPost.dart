// ignore_for_file: non_constant_identifier_names, prefer_initializing_formals, unnecessary_this, empty_constructor_bodies

class WorkerItem {
  String UserName;
  String location;
  String phone;
  String title;
  int price;
  String ImagePath;
  String description;
  String category;

  WorkerItem(
      {required this.category,
      required this.UserName,
      required this.title,
      required this.location,
      required this.price,
      required this.phone,
      required this.ImagePath,
      required this.description}) {
  }
}
