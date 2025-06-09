import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; // untuk Web

import 'package:projectakhir_praktpm/models/wish_model.dart';
import 'package:projectakhir_praktpm/services/wish_service.dart';
import 'package:projectakhir_praktpm/pages/home_page.dart';

class CreateWishPage extends StatefulWidget {
  final String username;
  const CreateWishPage({super.key, required this.username});

  @override
  State<CreateWishPage> createState() => _CreateWishPageState();
}

class _CreateWishPageState extends State<CreateWishPage> {
  final title = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  final image = TextEditingController(); // Untuk menyimpan URL dari Cloudinary
  final priorityList = ["Low", "Medium", "High"];
  final categoryList = ["Clothes", "Gadget", "Hobby", 'Electronic'];
  String category = "Clothes";
  String priority = "Low";

  File? _imageFile; // untuk mobile
  Uint8List? _webImage; // untuk web
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImage = result.files.single.bytes;
          _imageFile = null; // kosongkan jika pakai web
        });
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null; // kosongkan jika pakai file
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null && _webImage == null) {
      showErrorDialog('Please select an image first.');
      return;
    }

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dpqyi5rst/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'meong12';

    if (kIsWeb && _webImage != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _webImage!,
          filename: 'upload.jpg',
        ),
      );
    } else if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _imageFile!.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonMap = jsonDecode(responseData);
      setState(() {
        _imageUrl = jsonMap['secure_url'];
        image.text = _imageUrl!;
      });
    } else {
      showErrorDialog('Upload gagal. Status: ${response.statusCode}');
    }
  }

  void submitData() {
    if (title.text.isEmpty ||
        price.text.isEmpty ||
        desc.text.isEmpty ||
        image.text.isEmpty) {
      showErrorDialog('Field tidak boleh kosong 😠');
      return;
    }

    final priceValue = int.tryParse(price.text);
    if (priceValue == null) {
      showErrorDialog('Price harus berupa angka');
      return;
    }

    print("Final image URL: ${image.text}"); // <-- Tambahkan di sini
    _createWishes(context);
  }

  Future<void> _createWishes(BuildContext context) async {
    try {
      Wishes newWish = Wishes(
        title: title.text.trim(),
        price: int.parse(price.text),
        desc: desc.text.trim(),
        category: category,
        priority: priority,
        image: image.text.trim(),
        acquired: false, // Set default acquired ke false
      );

      final response = await WishApi.createWish(newWish);

      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New Wish Added")),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(username: widget.username),
          ),
        );
      } else {
        throw Exception(response["message"]);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Wish")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: desc,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description),
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: category,
              items: categoryList.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  category = value!;
                });
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: priority,
              items: priorityList.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  priority = value!;
                });
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () async {
                await _pickImage();
                await _uploadImage();
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text("Pilih & Upload Gambar"),
            ),
            const SizedBox(height: 10),

            // PREVIEW GAMBAR
            if (kIsWeb && _webImage != null)
              Image.memory(_webImage!, height: 150),
            if (_imageFile != null)
              Image.file(_imageFile!, height: 150),
            if (_imageUrl != null)
              Column(
                children: [
                  const Text("Uploaded Image:"),
                  Image.network(_imageUrl!, height: 150),
                  Text(_imageUrl!),
                ],
              ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: submitData,
              icon: const Icon(Icons.add),
              label: const Text("Create Wish"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
