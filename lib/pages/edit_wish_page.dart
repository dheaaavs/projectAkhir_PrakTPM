import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:projectakhir_praktpm/models/wish_model.dart';
import 'package:projectakhir_praktpm/services/wish_service.dart';
import 'package:projectakhir_praktpm/pages/home_page.dart';

class EditWishPage extends StatefulWidget {
  final String username;
  final int id;

  const EditWishPage({super.key, required this.username, required this.id});

  @override
  State<EditWishPage> createState() => _EditWishPageState();
}

class _EditWishPageState extends State<EditWishPage> {
  final title = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();
  final priority = TextEditingController();
  final image = TextEditingController();

  final categoryList = ["Clothes", "Gadget", "Hobby"];
  late String category = categoryList[0];
  late bool acquired = false;
  bool isLoaded = false;

  File? _imageFile;
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
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      showErrorDialog('Please select an image first.');
      return;
    }

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dpqyi5rst/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'meong12'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonMap = jsonDecode(responseData);
      setState(() {
        image.text = jsonMap['secure_url'];
      });
    } else {
      showErrorDialog('Upload gagal. Status: ${response.statusCode}');
    }
  }

  void updateWish() async {
    if (title.text.isEmpty ||
        price.text.isEmpty ||
        desc.text.isEmpty ||
        priority.text.isEmpty ||
        image.text.isEmpty) {
      showErrorDialog("Semua field wajib diisi!");
      return;
    }

    final priceValue = int.tryParse(price.text);
    if (priceValue == null) {
      showErrorDialog("Price harus angka");
      return;
    }

    try {
      Wishes updatedWish = Wishes(
        id: widget.id,
        title: title.text.trim(),
        price: priceValue,
        desc: desc.text.trim(),
        category: category,
        priority: priority.text.trim(),
        image: image.text.trim(),
        acquired: acquired,
      );

      final result = await WishApi.updateWishById(updatedWish);

      if (result['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wish berhasil diperbarui")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(username: widget.username)),
        );
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      showErrorDialog("Gagal memperbarui wish: $e");
    }
  }

  @override
  void dispose() {
    title.dispose();
    price.dispose();
    desc.dispose();
    priority.dispose();
    image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Wish")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: WishApi.getWishById(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error loading data");
            } else if (snapshot.hasData) {
              if (!isLoaded) {
                final wishUpdate = Wishes.fromJson(snapshot.data!["data"]);
                title.text = wishUpdate.title!;
                price.text = wishUpdate.price!.toString();
                desc.text = wishUpdate.desc!;
                category = wishUpdate.category!;
                image.text = wishUpdate.image!; // ✅ fix disini
                priority.text = wishUpdate.priority!;
                acquired = wishUpdate.acquired!;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    isLoaded = true;
                  });
                });
              }

              return ListView(
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: desc,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: category,
                    items: categoryList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) => setState(() => category = value!),
                    decoration: const InputDecoration(
                      labelText: "Category",
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priority,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Priority",
                      prefixIcon: Icon(Icons.priority_high),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pilih Gambar'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    child: const Text('Upload ke Cloudinary'),
                  ),
                  const SizedBox(height: 10),
                  if (_imageFile != null)
                    Image.file(_imageFile!, height: 150),
                  if (image.text.isNotEmpty)
                    Column(
                      children: [
                        const Text("Uploaded Image:"),
                        Image.network(image.text, height: 150),
                      ],
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Acquired?"),
                      Switch(
                        value: acquired,
                        onChanged: (value) => setState(() => acquired = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: updateWish,
                    icon: const Icon(Icons.save),
                    label: const Text("Update Wish"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
