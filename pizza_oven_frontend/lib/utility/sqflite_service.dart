import 'package:path/path.dart';
import 'package:pizza_oven_frontend/cart/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';

class AppDataBase {
  AppDataBase._privateConstructor();
  static final AppDataBase instance = AppDataBase._privateConstructor();

  static Database? _dataBase;

  Future<Database> get database async {
    if (_dataBase != null) {
      return _dataBase!;
    }

    _dataBase = await _initDatabase();
    return _dataBase!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "pizza_local_db.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
                        CREATE TABLE cart (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        pizza_id INTEGER NOT NULL,
                        name TEXT NOT NULL,
                        price REAL NOT NULL,
                        size TEXT NOT NULL,
                        quantity INTEGER NOT NULL,
                        UNIQUE(pizza_id, size)
                        );
    ''');
  }


  Future<int> insertInCart(Cart cart) async{
    final db = await AppDataBase.instance.database;
    return await db.rawInsert('''
    INSERT INTO cart (pizza_id, name, price, size, quantity)
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(pizza_id, size)
    DO UPDATE SET quantity = quantity + excluded.quantity
  ''', [cart.pizzaId, cart.name, cart.price, cart.size, cart.quantity]);
  }

  Future<List<Cart>> getCart() async{
    final db = await AppDataBase.instance.database;

    final List<Map<String, dynamic>> result = await db.query('cart');

    return result.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> updateCartQuantity({
  required int cartId,
  required int quantity,
}) async {
  final db = await AppDataBase.instance.database;

  return await db.update(
    'cart',
    {
      'quantity': quantity,
    },
    where: 'id = ?',
    whereArgs: [cartId],
  );
}

  Future<int> deleteById(int id) async{
    final db = await AppDataBase.instance.database;

    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteCart() async{
    final db = await AppDataBase.instance.database;

    return db.delete('cart');
  }

}
