import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _items = [];

  // Hàm hiển thị hộp thoại để thêm hoặc chỉnh sửa mục
  void _showDialog({String? currentItem, int? index}) {
    TextEditingController _controller = TextEditingController(
      text: currentItem ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(currentItem == null ? 'Thêm mục mới' : 'Chỉnh sửa mục'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Nhập nội dung mục'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(currentItem == null ? 'Thêm' : 'Lưu'),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    if (currentItem == null) {
                      _items.add(_controller.text);
                    } else {
                      _items[index!] = _controller.text;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm xóa mục
  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: _items.isEmpty
          ? Center(child: Text('Danh sách trống'))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showDialog(currentItem: _items[index], index: index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteItem(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
