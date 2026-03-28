import 'package:cloud_firestore/cloud_firestore.dart';
class MenuItemModel {
  final String name;
  final double price;
  final String desc;
  final String image;
  final String category;

  MenuItemModel({
    required this.name,
    required this.price,
    required this.desc,
    required this.image,
    required this.category,
  });

  factory MenuItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MenuItemModel(
      name: data['name'],
      price: data['price'],
      desc: data['desc'],
      image: data['image'],
      category: data['category'],
    );
  }
}