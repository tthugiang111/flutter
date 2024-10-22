import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Khai báo biến lưu trạng thái chế độ tối

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(), // Thay đổi theme dựa vào _isDarkMode
      home: Scaffold(
        appBar: AppBar(
          title: Text('Giao Diện Người Dùng'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Chào mừng bạn đến với ứng dụng!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Image.network(
                  'https://img.thuthuatphanmem.vn/uploads/2018/10/26/anh-nen-thien-nhien-cho-may-tinh-cuc-dep_091927826.jpg',
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Hiển thị'),
                  onPressed: () {
                    Text(
                      'Haha',
                    );
                  }
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chuyển chế độ: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Switch(
                      value: _isDarkMode, // Trạng thái hiện tại của switch
                      onChanged: (value) { // Hàm gọi khi switch thay đổi
                        setState(() { // Gọi setState để cập nhật giao diện
                          _isDarkMode = value; // Cập nhật trạng thái chế độ tối
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}