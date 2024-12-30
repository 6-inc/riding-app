import 'package:flutter/material.dart';
import 'package:riding_app/models/horse.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:riding_app/services/horse_service.dart';

class HorseEditPage extends StatefulWidget {
  final Horse horse;
  HorseEditPage({required this.horse});

  @override
  _HorseEditPageState createState() => _HorseEditPageState();
}

class _HorseEditPageState extends State<HorseEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;
  late TextEditingController _noteController;
  File? _imageFile;
  final HorseService horseService = HorseService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.horse.name);
    _breedController = TextEditingController(text: widget.horse.breed);
    _colorController = TextEditingController(text: widget.horse.color);
    _noteController = TextEditingController(text: widget.horse.description);
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.horse.imageUrl != null && widget.horse.imageUrl!.isNotEmpty) {
      final file = File(widget.horse.imageUrl!);
      if (await file.exists()) {
        setState(() {
          _imageFile = file;
        });
      } else {
        // Handle the case where the image file does not exist
        print('Image file does not exist: ${widget.horse.imageUrl}');
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('編集')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: _imageFile != null
                        ? ClipOval(
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.add_a_photo, size: 40),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '名前'),
            ),
            TextField(
              controller: _breedController,
              decoration: InputDecoration(labelText: '品種'),
            ),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: '毛色'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'メモ'),
            ),
            ElevatedButton(
              onPressed: () {
                final name =
                    _nameController.text.isNotEmpty ? _nameController.text : '';
                final breed = _breedController.text.isNotEmpty
                    ? _breedController.text
                    : '';
                final color = _colorController.text.isNotEmpty
                    ? _colorController.text
                    : '';
                final description =
                    _noteController.text.isNotEmpty ? _noteController.text : '';
                final imageUrl =
                    _imageFile?.path ?? widget.horse.imageUrl ?? '';

                final updatedHorse = Horse(
                  id: widget.horse.id,
                  name: name,
                  breed: breed,
                  color: color,
                  description: description,
                  imageUrl: imageUrl,
                );

                horseService.updateHorse(updatedHorse).then((_) {
                  print('Horse updated successfully');
                  Navigator.pop(context, updatedHorse);
                }).catchError((error) {
                  print('Failed to update horse: $error');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update horse: $error')),
                  );
                });
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
