import 'package:flutter/material.dart';
import 'Loginnya.dart';
import 'Transaksi.dart';
import 'DetailTransaksinya.dart';
import 'Dashboardnya.dart'; // Import DashboardPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warmindo Starboy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Loginnya(),
      // initialRoute: '/transaction-detail',
      // routes: {
      //   '/login': (context) => Loginnya(),
      //   '/register': (context) => Registrasi(),
      //   '/dashboard': (context) => Dashboardnya(),
      //   '/transaction': (context) => Transaksi(),
      //   '/transaction-detail': (context) => DetailTransaksinya(),
      // },
    );
  }
}
