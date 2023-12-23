import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbpyahu/Transaksi.dart';

class Dashboardnya extends StatefulWidget {
  final String accessToken;

  const Dashboardnya({Key? key, required this.accessToken}) : super(key: key);

  @override
  State<Dashboardnya> createState() => _DashboardnyaState();
}

class _DashboardnyaState extends State<Dashboardnya> {
  String namapengguna = '';
  String selectedShift = 'Shift 2';

  @override
  void initState() {
    super.initState();
    userData(); // Panggil fungsi untuk mengambil informasi pengguna saat widget diinisialisasi
  }

  Future<void> userData() async {
    final url = Uri.parse('http://localhost:3000/me');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          namapengguna = responseData[
              'namapengguna']; // Simpan nama pengguna dari respons server
        });
      } else {
        final errorMessage = json.decode(response.body)['message'];
        print(errorMessage);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

    Future<void> shiftData(String selectedShift) async {
    final shift = selectedShift == 'Shift 2' ? 1 : 2;
    final url = Uri.parse('http://localhost:3000/transaksi?shift=$shift');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransaksiPage(
              accessToken: widget.accessToken,
              selectedShift: selectedShift,
            ),
          ),
        );
      } else {
        print('Fetch Data Gagal');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ... bagian yang sama dengan sebelumnya ...
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Selamat Datang $namapengguna', // Tampilkan nama pengguna di sini
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                          SizedBox(height: 4),
                          Text(
                            'Shift Aktif',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              shiftData(selectedShift);
                            },
                            child: Text('Shift 2'),
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

