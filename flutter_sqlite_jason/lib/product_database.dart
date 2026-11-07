import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'product.dart';

import 'package:flutter/foundation.dart';

/// The products table in a SQLite database that lives in the browser (IndexedDB).
class ProductDatabase {
  ProductDatabase._(this._db);

  final Database _db;

  static Future<ProductDatabase> open() async {
    final db = await databaseFactoryFfiWeb.openDatabase(
      'products.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, price REAL NOT NULL, quantity INTEGER NOT NULL)',
          );
          // Two starter products, so the list has something to show on the first run.
          await db.insert('products', {
            'name': 'Coffee Mug',
            'price': 12.99,
            'quantity': 100,
          });
          await db.insert('products', {
            'name': 'Notebook',
            'price': 5.99,
            'quantity': 50,
          });
        },
      ),
    );
    return ProductDatabase._(db);
  }

  /// Adds a product. Without an [id], SQLite assigns the next one.
  Future<Product> add({
    int? id,
    required String name,
    required double price,
    required int quantity,
  }) async {
    try {
      final newId = await _db.insert('products', {
        if (id != null) 'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
      });
      return Product(id: newId, name: name, price: price, quantity: quantity);
    } on DatabaseException catch (e) {
      debugPrint('DatabaseException: $e');
      rethrow;
    }
  }

  Future<List<Product>> all() async {
    final rows = await _db.query('products', orderBy: 'id');
    return rows.map(Product.fromRow).toList();
  }
}
