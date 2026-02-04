import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final int itemCount;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.itemCount,
  });
}

List<Category> getDummyCategories() {
  return [
    Category(
      id: '1',
      name: 'Electronics',
      icon: Icons.devices_outlined,
      itemCount: 89,
    ),
    Category(
      id: '2',
      name: 'Books',
      icon: Icons.book_outlined,
      itemCount: 124,
    ),
    Category(
      id: '3',
      name: 'Clothing',
      icon: Icons.checkroom_outlined,
      itemCount: 156,
    ),
    Category(
      id: '4',
      name: 'Furniture',
      icon: Icons.weekend_outlined,
      itemCount: 43,
    ),
    Category(
      id: '5',
      name: 'Sports',
      icon: Icons.sports_basketball_outlined,
      itemCount: 67,
    ),
    Category(
      id: '6',
      name: 'Stationery',
      icon: Icons.edit_outlined,
      itemCount: 32,
    ),
    Category(
      id: '7',
      name: 'Others',
      icon: Icons.more_horiz,
      itemCount: 78,
    ),
  ];
}
