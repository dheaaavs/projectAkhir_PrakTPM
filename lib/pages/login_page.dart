import 'package:flutter/material.dart';
import 'package:projectakhir_praktpm/pages/home_page.dart';
import 'package:projectakhir_praktpm/util/local_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isError = false;
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe1a370),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Sign in to access your dashboard.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
              const Text(
                "Username",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _username,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIcon: Icon(Icons.account_circle, color: Colors.white),
                  filled: true,
                  fillColor: isError ? Colors.red.shade100 : Color(0xffe3d9a6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Password",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _password,
                obscureText: isObsecure,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  filled: true,
                  fillColor: isError ? Colors.red.shade100 : Color(0xffe3d9a6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    child: Icon(
                      isObsecure ? Icons.remove_red_eye : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String msg = "";
                    if (_username.text == "123220134" &&
                        _password.text == "12345678") {
                      msg = "Login berhasil";
                      setState(() {
                        isError = false;
                      });

                      // Pindah ke halaman HomePage
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              HomePage(username: _username.text),
                        ),
                      );
                      await LocalStorage.login(_username.text.trim());
                    } else {
                      msg = "Username/Password salah";
                      isError = true;
                    }

                    SnackBar snackbar = SnackBar(content: Text(msg));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff587e8b),
                    padding:
                    EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
