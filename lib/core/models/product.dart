class Product {
  final String id;
  final String name;
  final double price;
  final String seller;
  final String condition;
  final String category;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.seller,
    required this.condition,
    required this.category,
    this.imageUrl,
  });
}

List<Product> getDummyProducts() {
  return [
    Product(
      id: '1',
      name: 'MacBook Pro 2021 M1',
      price: 4500.00,
      seller: 'Ahmad Faisal',
      condition: 'Used',
      category: 'Electronics',
    ),
    Product(
      id: '2',
      name: 'Calculus Textbook',
      price: 45.00,
      seller: 'Nurul Izzah',
      condition: 'New',
      category: 'Books',
    ),
    Product(
      id: '3',
      name: 'iPhone 13 Pro Max',
      price: 3200.00,
      seller: 'Muhammad Hafiz',
      condition: 'Used',
      category: 'Electronics',
    ),
    Product(
      id: '4',
      name: 'Study Desk Set',
      price: 280.00,
      seller: 'Siti Aminah',
      condition: 'Used',
      category: 'Furniture',
    ),
    Product(
      id: '5',
      name: 'Gaming Headset',
      price: 150.00,
      seller: 'Ismail Rahman',
      condition: 'New',
      category: 'Electronics',
    ),
    Product(
      id: '6',
      name: 'Blue T-Shirt',
      price: 25.00,
      seller: 'Fatimah Ali',
      condition: 'New',
      category: 'Clothing',
    ),
    Product(
      id: '7',
      name: 'Basketball',
      price: 40.00,
      seller: 'Hassan Yusof',
      condition: 'Used',
      category: 'Sports',
    ),
    Product(
      id: '8',
      name: 'Office Chair',
      price: 180.00,
      seller: 'Aisha Karim',
      condition: 'Used',
      category: 'Furniture',
    ),
  ];
}
