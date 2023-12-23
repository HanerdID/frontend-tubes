import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:pbpyahu/DetailTransaksinya.dart';

class Transaksi {
  final int idTransaksi;
  final DateTime tanggal;
  final String waktu;
  final String shift;
  final int idPengguna;
  final String idPelanggan;
  final String status;
  final String kodeMeja;
  final String namaPelanggan;
  final int total;
  final String metodePembayaran;
  final String totalDiskon;
  final int idPromosi;

  Transaksi({
    required this.idTransaksi,
    required this.tanggal,
    required this.waktu,
    required this.shift,
    required this.idPengguna,
    required this.idPelanggan,
    required this.status,
    required this.kodeMeja,
    required this.namaPelanggan,
    required this.total,
    required this.metodePembayaran,
    required this.totalDiskon,
    required this.idPromosi,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      idTransaksi: json['idtransaksi'] as int,
      tanggal: DateTime.parse(json['tanggal']),
      waktu: json['waktu'] as String,
      shift: json['shift'] as String,
      idPengguna: json['idpengguna'] as int,
      idPelanggan: json['idpelanggan'] as String,
      status: json['status'] as String,
      kodeMeja: json['kodemeja'] as String,
      namaPelanggan: json['namapelanggan'] as String,
      total: int.parse(json['total']), // Convert String to int
      metodePembayaran: json['metodepembayaran'] as String,
      totalDiskon: json['totaldiskon'] as String,
      idPromosi: json['idpromosi'] as int,
    );
  }
}

var logger = Logger();

class TransaksiPage extends StatelessWidget {
  final String accessToken;
  final String selectedShift;

  const TransaksiPage({
    Key? key,
    required this.accessToken,
    required this.selectedShift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Transaksi $selectedShift'),
      ),
      body: FutureBuilder<List<Transaksi>>(
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak Terdapat Transaksi'));
          } else {
            print(snapshot.data);
            return listTransaksi(snapshot.data!);
          }
        },
      ),
    );
  }

  Future<List<Transaksi>> fetchTransactions() async {
    final shift = selectedShift == 'Shift 2' ? 1 : 2;

    final url = Uri.parse('http://localhost:3000/transaksi?shift=$shift');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'shift': selectedShift}),
      );

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);

        if (decodedData is Map<String, dynamic>) {
          List<Transaksi> transactions = [Transaksi.fromJson(decodedData)];
          logger.i('Transaction fetched: $transactions');
          return transactions;
        } else if (decodedData is List<dynamic>) {
          List<Transaksi> transactions = decodedData.map((data) {
            return Transaksi.fromJson(data);
          }).toList();
          logger.i('Transactions fetched: $transactions');
          return transactions;
        } else {
          throw Exception('Fetch Data Gagal');
        }
      } else {
        throw Exception('Fetch Data Gagal');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Widget listTransaksi(List<Transaksi> transactions) {
    return Scaffold(
      // padding: const EdgeInsets.all(16.0),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/WarmindoStarboy.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailTransaksinya(
                  idTransaksi: transaction.idTransaksi,
                  accessToken: accessToken,
                  selectedShift: selectedShift,
                );
              }));
            },
            child: Card(
              child: ListTile(
                title: Text('Transaction ID: ${transaction.idTransaksi}'),
                subtitle: Text('Total: ${transaction.total}'),
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}