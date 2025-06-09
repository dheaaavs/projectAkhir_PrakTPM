import 'package:flutter/material.dart';
import 'package:projectakhir_praktpm/models/wish_model.dart';
import 'package:projectakhir_praktpm/services/wish_service.dart';

class DetailWishPage extends StatefulWidget {
  final int id;
  final String username;

  const DetailWishPage({super.key, required this.username, required this.id});

  @override
  State<DetailWishPage> createState() => _DetailWishPageState();
}

class _DetailWishPageState extends State<DetailWishPage> {
  Wishes? wish;
  bool isLoading = true;
  String selectedCurrency = 'IDR';

  @override
  void initState() {
    super.initState();
    fetchWishDetail();
  }

  void fetchWishDetail() async {
    try {
      var response = await WishApi.getWishById(widget.id);
      setState(() {
        wish = Wishes.fromJson(response['data']);
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6fa),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Detail Wish",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wish == null
          ? const Center(child: Text("Data not found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    wish!.image ?? "-",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                detailItem(Icons.title, "Title", wish!.title ?? "-"),
                detailItem(Icons.category, "Category", wish!.category ?? "-"),
                detailItem(Icons.attach_money, "Price", wish!.price?.toString() ?? "-"),
                detailItem(Icons.flag, "Priority", wish!.priority ?? "-"),
                detailItem(Icons.flag, "Description", wish!.desc ?? "-"),
                detailItem(Icons.check_circle, "Acquired", wish!.acquired == true ? "Yes" : "No")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
