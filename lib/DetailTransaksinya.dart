import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pbpyahu/Transaksi.dart';

class DetailTransaksinya extends StatefulWidget {
  final int idTransaksi;
  final String accessToken;
  final String selectedShift;
  
  const DetailTransaksinya(
      {Key? key,
      required this.idTransaksi,
      required this.accessToken,
      required this.selectedShift})
      : super(key: key);

  @override
  State<DetailTransaksinya> createState() => _DetailTransaksinyaState();
}

class _DetailTransaksinyaState extends State<DetailTransaksinya> {
  // String _selectedStatus = 'Baru';
  var selectedPayment = null;
  
  Future<Map<String, dynamic>> fetchdetailTransaksi(int idTransaksi) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/detailTransaksi/$idTransaksi'),
    );
    Map<String, dynamic> detailTransaksi = json.decode(response.body);

    return detailTransaksi;
  }

  Future<void> updateStatusTransaksi() async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:3000/updateDetailTransaksi/${widget.idTransaksi}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return DetailTransaksinya(
            idTransaksi: widget.idTransaksi,
            accessToken: widget.accessToken,
            selectedShift: widget.selectedShift,
          );
        }));
      } else {
        print('Failed to update transaction status');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> selesaikanTransaksi() async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:3000/deletedetailTransaksi/${widget.idTransaksi}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return TransaksiPage(
              accessToken: widget.accessToken,
              selectedShift: widget.selectedShift);
        }));
      } else {
        print('Failed to delete transaction');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateMetodePembayaran(String method) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://localhost:3000/updateMetodePembayaran/${widget.idTransaksi}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'metodepembayaran': method}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Berhasil mengubah metode pembayaran"),
        ));
      } else {
        print('Failed to update transaction status');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: fetchdetailTransaksi(widget.idTransaksi),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Tidak ada data yang tersedia'));
            } else {
              return buildDetailTransaksi(
                  snapshot.data as Map<String, dynamic>);
            }
          },
        ),
      ),
    );
  }

  Widget buildDetailTransaksi(Map<String, dynamic> transaction) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/WarmindoStarboy.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white.withOpacity(0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      'ID Transaksi: ${transaction['idtransaksi']}', //masukin dari random number generat aja atauga id transaksi
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      'ID Menu: ${transaction['idmenu']}', // total dari semua harnganya yee ini
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    title: Text('Nama Menu: ${transaction['namamenu']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga: ${transaction['harga']}'),
                        Text('Jumlah: ${transaction['jumlah']}'),
                        Text('SubTotal: ${transaction['subtotal']}'),
                        Text('Status: ${transaction['status']}'),
                        // Text('Status:'),
                        // DropdownButton<String>(
                        //   value: _selectedStatus,
                        //   onChanged: (newValue) {
                        //     setState(() {
                        //       _selectedStatus = newValue!;
                        //     });
                        //   },
                        //   items: <String>[
                        //     'Baru',
                        //     'Diproses',
                        //     'Disajikan',
                        //     'Selesai'
                        //   ].map<DropdownMenuItem<String>>((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value,
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        // ),
                        Text('Metode Pembayaran:'),
                        DropdownButton<String>(
                          value: selectedPayment,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedPayment = newValue;
                                switch (newValue) {
                                  case 'Cash':
                                    newValue = 'cash';
                                    break;
                                  case 'Kartu Kredit':
                                    newValue = 'kartu kredit';
                                    break;
                                  case 'Kartu Debit':
                                    newValue = 'kartu debit';
                                    break;
                                  case 'QRIS':
                                    newValue = 'qris';
                                    break;
                                }
                                updateMetodePembayaran(newValue!);
                                fetchdetailTransaksi(widget.idTransaksi);
                              });
                            }
                          },
                          items: <String>[
                            'Cash',
                            'Kartu Kredit',
                            'Kartu Debit',
                            'QRIS'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          updateStatusTransaksi();
                        },
                        child: Text('Update Status'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          selesaikanTransaksi();
                        },
                        child: Text('Selesaikan Transaksi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
