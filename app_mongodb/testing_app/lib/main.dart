import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MongoDemo(),
    );
  }
}

class MongoDemo extends StatefulWidget {
  const MongoDemo({Key? key}) : super(key: key);

  @override
  MongoDemoState createState() => MongoDemoState();
}

class MongoDemoState extends State<MongoDemo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<dynamic> _users = [];

  Future<void> _loadData() async {
    try {
      final data = await ApiService.getData();
      setState(() => _users = data);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> _submitData() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) return;
    
    try {
      await ApiService.addData(_nameController.text, _emailController.text);
      _nameController.clear();
      _emailController.clear();
      await _loadData();
      Fluttertoast.showToast(msg: "Data saved successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MongoDB Demo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Save to Database'),
            ),
            SizedBox(height: 20),
            Text('Stored Data:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}