import 'dart:convert';
import 'package:projectakhir_praktpm/models/wish_model.dart';
import 'package:http/http.dart' as http;

class WishApi{
  static const url = "https://tpm-api-559917148272.us-central1.run.app/wish";

  //mengambil data wish
  static Future<Map<String, dynamic>> getWish() async {
    print("📤 [GET] Fetching wish data from $url");

    final response = await http.get(Uri.parse(url));

    print("📥 [GET] Response status: ${response.statusCode}");
    print("📥 [GET] Response body: ${response.body}");

    return jsonDecode(response.body);
  }

  //membuat data wish baru
  static Future<Map<String, dynamic>> createWish(Wishes wish) async {
    print("📤 [CREATE] Sending request to $url");
    print("📤 [CREATE] Request body: ${jsonEncode(wish)}");

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(wish),
    );

    print("📥 [CREATE] Response status: ${response.statusCode}");
    print("📥 [CREATE] Response body: ${response.body}");

    return jsonDecode(response.body);
  }

  //menghapus data wish
  static Future<Map<String, dynamic>> deleteWish(int id) async {
    final response = await http.delete(Uri.parse("$url/$id"));
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    return jsonDecode(response.body);
  }

  //mengambil data wish berdasarkan id
  static Future<Map<String, dynamic>> getWishById(int id) async {
    final response = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }

  //update wish by id
  static Future<Map<String, dynamic>> updateWishById(Wishes wish) async {
    final response = await http.patch(
        Uri.parse("$url/${wish.id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "title": wish.title,
          "price": wish.price,
          "category": wish.category,
          "desc": wish.desc,
          "image": wish.image,
          "priority": wish.priority,
          "acquired": wish.acquired
        })
    );
    return jsonDecode(response.body);
  }

}