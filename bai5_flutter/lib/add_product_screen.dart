import 'package:flutter/material.dart';
import 'product_database.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  _saveProduct() async {
    String name = _nameController.text;
    double? price = double.tryParse(_priceController.text);

    if (name.isEmpty || price == null) {
      // Hiển thị cảnh báo nếu thông tin không hợp lệ
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Vui lòng nhập đầy đủ thông tin sản phẩm'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    Product newProduct = Product(name: name, price: price);
    await ProductDatabase().insertProduct(newProduct);

    Navigator.pop(context, true); // Quay lại và trả về kết quả thành công
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm Sản Phẩm')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên Sản Phẩm'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Giá Sản Phẩm'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text('Lưu Sản Phẩm'),
            ),
          ],
        ),
      ),
    );
  }
}
