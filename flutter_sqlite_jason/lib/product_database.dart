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
      'products',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE products ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT NOT NULL, '
            'price REAL NOT NULL, '
            'quantity INTEGER NOT NULL'
            ' )',
          );

          //await testdata(db);
        },
      ),
    );
    return ProductDatabase._(db);
  }

  static Future<void> testdata(Database db) async {
    await db.insert('products', {
      'name': 'Coffee Pot',
      'price': 42.99,
      'quantity': 100,
    });
    await db.insert('products', {
      'name': 'Windows Laptop',
      'price': 512.99,
      'quantity': 50,
    });
    await db.insert('products', {
      'name': 'Tennis Shoes',
      'price': 32.99,
      'quantity': 15,
    });
    await db.insert('products', {
      'name': 'Hot Dog',
      'price': 3.99,
      'quantity': 150,
    });
  }

  /// Adds a product. Without an [id], SQLite assigns the next one.
  Future<Product> add({
    required String name,
    required double price,
    required int quantity,
  }) async {
    try {
      final newId = await _db.insert('products', {
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
