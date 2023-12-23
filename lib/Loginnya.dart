import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbpyahu/Dashboardnya.dart';


class Loginnya extends StatefulWidget {
  const Loginnya({super.key});

  @override
  State<Loginnya> createState() => _LoginnyaState();
}

Future<void> loginUser(
    String username, String password, BuildContext context) async {
  final url = Uri.parse('http://localhost:3000/login');

  try {
    final response = await http.post(
      url,
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final accessToken = responseData['accessToken'];
      // Lakukan sesuatu dengan token, seperti menyimpannya ke SharedPreferences
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboardnya(
                  accessToken: accessToken,
                )),
      );
    } else {
      final errorMessage = json.decode(response.body)['message'];
      print(errorMessage);
    }
  } catch (error) {
    print('Error: $error');
  }
}

class _LoginnyaState extends State<Loginnya> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/WarmindoStarboy.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: ListView(
              children: [
                Image.asset(
                  'lib/assets/logo warmindo.jpeg',
                  width: 300.0,
                  height: 300.0,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.white.withOpacity(0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              loginUser(
                                _usernameController.text,
                                _passwordController.text,
                                context,
                              );
                            },
                            child: Text('Login'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 67, 29, 114)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
