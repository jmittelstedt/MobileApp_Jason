class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  final int id;
  final String name;
  final double price;
  final int quantity;

  factory Product.fromRow(Map<String, Object?> row) => Product(
    id: row['id']! as int,
    name: row['name']! as String,
    price: row['price']! as double,
    quantity: row['quantity']! as int,
  );
}
