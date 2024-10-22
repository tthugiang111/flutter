import 'package:flutter/material.dart';
import 'order_form_screen.dart';
import 'product_database.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giỏ Hàng')),
      body: FutureBuilder<List<Product>>(
        future: ProductDatabase().getProductsInCart(), // Lấy danh sách sản phẩm trong giỏ hàng
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;
          if (products.isEmpty) {
            return Center(child: Text('Giỏ hàng trống'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('${product.price} VND'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Kiểm tra nếu giỏ hàng không trống trước khi chuyển sang OrderFormScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderFormScreen()), // Điều hướng đến OrderFormScreen
          );
        },
        child: Icon(Icons.check_outlined),
        tooltip: 'Đặt hàng',
      ),
    );
  }
}
