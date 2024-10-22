import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Product {
  final int? id;
  final String name;
  final double price;

  Product({this.id, required this.name, required this.price});

  // Factory method to create a Product instance from a map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }

  // Convert Product instance to a map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'in_cart': 0, // Mặc định không nằm trong giỏ hàng khi tạo sản phẩm mới
    };
  }
}

class ProductDatabase {
  // Singleton instance of ProductDatabase
  static final ProductDatabase _instance = ProductDatabase._internal();
  Database? _database;

  ProductDatabase._internal();

  // Factory constructor to return the singleton instance
  factory ProductDatabase() => _instance;

  // Getter for the database, initializing it if it's null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize and open the database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'shopping.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the products table with autoincrement for the primary key
        await db.execute(''' 
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Autoincrement for ID
            name TEXT NOT NULL,
            price REAL NOT NULL,
            in_cart INTEGER DEFAULT 0  -- Thêm cột in_cart
          )
        ''');
      },
    );
  }

  // Insert a new product into the database
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Prevent duplicate entries
    );
  }

  // Method to add a product to the cart
  Future<void> addToCart(int productId) async {
    final db = await database;
    await db.update(
      'products',
      {'in_cart': 1}, // Cập nhật cột in_cart thành 1
      where: 'id = ?',
      whereArgs: [productId], // Xác định sản phẩm cần cập nhật bằng ID
    );
  }

  // Method to remove a product from the cart
  Future<void> removeFromCart(int productId) async {
    final db = await database;
    await db.update(
      'products',
      {'in_cart': 0}, // Cập nhật cột in_cart thành 0
      where: 'id = ?',
      whereArgs: [productId], // Xác định sản phẩm cần cập nhật bằng ID
    );
  }

  // Method to fetch all products from the database
  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    // Convert the list of maps to a list of products
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Method to fetch products in the cart
  Future<List<Product>> getProductsInCart() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'in_cart = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Update an existing product in the database
  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],  // Specify which product to update using the ID
    );
  }

  // Delete a product from the database
  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],  // Specify which product to delete using the ID
    );
  }

  // Close the database connection when not in use
  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
