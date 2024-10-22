import 'package:flutter/material.dart';
import 'task.dart';
import 'db_helper.dart';
import 'AddEditTaskScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    List<Task> loadedTasks = await DBHelper().getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  _deleteTask(int id) async {
    await DBHelper().deleteTask(id);
    _loadTasks();
  }

  _navigateToAddEditTask({Task? task}) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditTaskScreen(task: task)),
    );

    if (result == true) {
      _loadTasks(); // Tải lại danh sách sau khi thêm/sửa công việc
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks available.'))
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteTask(task.id!),
            ),
            onTap: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditTaskScreen(task: task), // Truyền công việc vào để chỉnh sửa
                ),
              );
              if (result == true) {
                _loadTasks(); // Tải lại danh sách sau khi cập nhật công việc
              }
            },

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Điều hướng đến màn hình thêm công việc mới
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(),
            ),
          );
          if (result == true) {
            _loadTasks(); // Tải lại danh sách sau khi thêm công việc
          }
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
