import 'package:flutter/material.dart';
import 'package:projectakhir_praktpm/models/wish_model.dart';
import 'package:projectakhir_praktpm/pages/create_wish_page.dart';
import 'package:projectakhir_praktpm/pages/edit_wish_page.dart';
import 'package:projectakhir_praktpm/services/wish_service.dart';
import 'package:projectakhir_praktpm/pages/detail_wish_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectakhir_praktpm/pages/login_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Halo, ${widget.username}",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _wishContainer(),
      ),
    );
  }

  // LOGOUT METHOD
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true); // set login jadi true (belum login)
    prefs.remove('username'); // hapus username

    // Navigasi ke login page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // WISH LIST CONTAINER
  Widget _wishContainer() {
    return FutureBuilder(
      future: WishApi.getWish(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error : ${snapshot.error.toString()}");
        } else if (snapshot.hasData) {
          WishModel response = WishModel.fromJson(snapshot.data!);
          return _wishList(context, response.data!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // WISH LIST VIEW (PAKE LISTVIEW.BUILDER)
  Widget _wishList(BuildContext context, List<Wishes> wish) {
    return ListView(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    CreateWishPage(username: widget.username),
              ),
           ).then((_) => setState(() {}));
          },
          child: const Text("Add Wish"),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: wish.length,
          itemBuilder: (context, index) {
            var itemWish = wish[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.blueGrey.shade50,
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    itemWish.image ?? "-",
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 90,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, size: 30, color: Colors.grey),
                      );
                    },
                  ),
                ),
                title: Text(
                  itemWish.title ?? "-",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text("Price: ${itemWish.price ?? "-"}"),
                    Text("Priority: ${itemWish.priority ?? "-"}"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Acquired badge
                        Chip(
                          label: Text(itemWish.acquired == true ? "Acquired" : "Not Acquired"),
                          backgroundColor: itemWish.acquired == true ? Colors.green : Colors.pinkAccent,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditWishPage(
                                  username: widget.username,
                                  id: itemWish.id!,
                                ),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: const Text("Edit"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _deleteWish(itemWish.id!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailWishPage(
                          username: widget.username, id: itemWish.id!),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // DELETE wish
  void _deleteWish(int id) async {
    try {
      final response = await WishApi.deleteWish(id);
      if (response["status"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["msg"] ?? "Wish deleted successfully")),
        );
        setState(() {});  // Refresh UI setelah delete
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete wish")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
