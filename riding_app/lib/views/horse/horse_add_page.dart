import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';

class HorseAddPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('馬を追加')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '名前'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<HorseService>(context, listen: false)
                    .addHorse(_nameController.text);
                Navigator.pop(context);
              },
              child: Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}
