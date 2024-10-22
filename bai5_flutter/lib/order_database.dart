import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class Order {
  final int? id;
  final String customerName;
  final String deliveryAddress;

  Order({this.id, required this.customerName, required this.deliveryAddress});

  // Phương thức factory để tạo một instance Order từ map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      customerName: map['customerName'],
      deliveryAddress: map['deliveryAddress'],
    );
  }

  // Chuyển đổi instance Order thành map để thực hiện các thao tác với cơ sở dữ liệu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'deliveryAddress': deliveryAddress,
    };
  }
}

class OrderDatabase {
  // Singleton instance của OrderDatabase
  static final OrderDatabase _instance = OrderDatabase._internal();
  Database? _database;

  OrderDatabase._internal();

  // Constructor factory để trả về instance singleton
  factory OrderDatabase() => _instance;

  // Getter cho cơ sở dữ liệu, khởi tạo nó nếu null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo và mở cơ sở dữ liệu
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'shopping.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tạo bảng orders với autoincrement cho khóa chính
        await db.execute(''' 
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Autoincrement cho ID
            customerName TEXT NOT NULL,
            deliveryAddress TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Chèn một đơn hàng mới vào cơ sở dữ liệu
  Future<void> insertOrder(Order order) async {
    final db = await database;
    await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Ngăn chặn việc trùng lặp
    );
  }

  // Lấy tất cả đơn hàng từ cơ sở dữ liệu
  Future<List<Order>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orders');

    // Chuyển đổi danh sách map thành danh sách đơn hàng
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  // Cập nhật một đơn hàng hiện có trong cơ sở dữ liệu
  Future<void> updateOrder(Order order) async {
    final db = await database;
    await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],  // Xác định đơn hàng nào cần cập nhật bằng ID
    );
  }

  // Xóa một đơn hàng khỏi cơ sở dữ liệu
  Future<void> deleteOrder(int id) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],  // Xác định đơn hàng nào cần xóa bằng ID
    );
  }

  // Đóng kết nối cơ sở dữ liệu khi không sử dụng
  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
