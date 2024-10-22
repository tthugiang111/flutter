import 'package:flutter/material.dart';
import 'order_database.dart';

class OrderFormScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông Tin Đặt Hàng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên Khách Hàng'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Địa Chỉ Giao Hàng'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String customerName = _nameController.text.trim();
                String deliveryAddress = _addressController.text.trim();

                if (customerName.isNotEmpty && deliveryAddress.isNotEmpty) {
                  Order newOrder = Order(
                    customerName: customerName,
                    deliveryAddress: deliveryAddress,
                  );

                  // Gọi hàm để lưu đơn hàng và chờ kết quả
                  bool success = await _saveOrder(newOrder, context);

                  if (success) {
                    // Quay lại màn hình trước khi đặt hàng
                    Navigator.pop(context);
                  }
                } else {
                  _showErrorDialog(context, "Vui lòng điền đầy đủ thông tin.");
                }
              },
              child: Text('Đặt Hàng'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _saveOrder(Order order, BuildContext context) async {
    try {
      await OrderDatabase().insertOrder(order);
      print("Đơn hàng đã được đặt cho ${order.customerName}, giao đến ${order.deliveryAddress}");
      return true; // Đơn hàng được lưu thành công
    } catch (e) {
      print("Lỗi khi lưu đơn hàng: $e");
      _showErrorDialog(context, "Đã xảy ra lỗi khi lưu đơn hàng.");
      return false; // Lưu đơn hàng không thành công
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
