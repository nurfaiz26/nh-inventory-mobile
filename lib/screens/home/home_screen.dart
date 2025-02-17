import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:nh_manajemen_inventory/models/log_transaksi.dart';
import 'package:nh_manajemen_inventory/screens/qrscan/qrscan_screen.dart';
import 'package:provider/provider.dart';
import 'package:nh_manajemen_inventory/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    Future<List<LogTransaksi>> fetchTransactionData() async {
      final response = await http.get(Uri.parse(
          'https://assets.itnh.systems/api/log?telepon=${userData!['telepon'].toString()}'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<LogTransaksi> logs = (jsonData['data'] as List)
            .map((data) => LogTransaksi.fromJson(data))
            .toList();
        return logs;
      } else {
        throw Exception('Failed to load data');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log Admin ${userData!['nama']}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF099AA7),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            color: Colors.white,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                child: Row(
                  children: [
                    Text(
                      userData['nama'].toString().toUpperCase(),
                      style: const TextStyle(color: Color(0xFF099AA7)),
                    ),
                    const Text(
                      ' - ',
                      style: TextStyle(color: Color(0xFF099AA7)),
                    ),
                    Text(
                      userData['level'].toString().toUpperCase(),
                      style: const TextStyle(color: Color(0xFF099AA7)),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Text(
                      userData['telepon'].toString().toUpperCase(),
                      style: const TextStyle(color: Color(0xFF099AA7)),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Color(0xFF099AA7),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'Logout',
                      style: TextStyle(color: Color(0xFF099AA7)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QrscanScreen()));
        }, // Icon to display on the button
        backgroundColor: const Color(0xFF099AA7),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
        ), // Background color of the button
      ),
      body: FutureBuilder<List<LogTransaksi>>(
        future: fetchTransactionData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final logs = snapshot.data!;

          return ListView.builder(
            itemCount: logs.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final log = logs[index];
              if (index + 1 < logs.length) {
                return ExpansionTile(
                  title: Text(log.inventaris.kode,
                      style: const TextStyle(
                          color: Color(0xFF099AA7),
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    DateFormat('dd-MM-yy')
                        .format(DateTime.parse(log.createdAt)),
                    style: const TextStyle(color: Color(0xFF099AA7)),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF099AA7),
                  ),
                  children: [
                    ListTile(
                      leading: const SizedBox(),
                      title: Text('Jumlah: ${log.jumlah}',
                          style: const TextStyle(
                              color: Color(0xFF099AA7),
                              fontWeight: FontWeight.bold)),
                      subtitle: Text('Total Harga: ${log.totalHarga}',
                          style: const TextStyle(color: Color(0xFF099AA7))),
                    ),
                    ListTile(
                      leading: const SizedBox(),
                      title: Text('Cabang ${log.transaksi.gudang.cabang.nama}',
                          style: const TextStyle(
                              color: Color(0xFF099AA7),
                              fontWeight: FontWeight.bold)),
                      subtitle: Text('Area ${log.inventaris.wilayah.nama}',
                          style: const TextStyle(color: Color(0xFF099AA7))),
                    ),
                    ListTile(
                      leading: const SizedBox(),
                      title: Text('Unit ${log.transaksi.unit.nama}',
                          style: const TextStyle(
                              color: Color(0xFF099AA7),
                              fontWeight: FontWeight.bold)),
                      subtitle: Text('Pengguna ${log.inventaris.pengguna}',
                          style: const TextStyle(color: Color(0xFF099AA7))),
                    ),
                    // Add more details as needed
                  ],
                );
              } else {
                return Column(
                  children: [
                    ExpansionTile(
                      title: Text(log.inventaris.kode,
                          style: const TextStyle(
                              color: Color(0xFF099AA7),
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        DateFormat('dd-MM-yy')
                            .format(DateTime.parse(log.createdAt)),
                        style: const TextStyle(color: Color(0xFF099AA7)),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF099AA7),
                      ),
                      children: [
                        ListTile(
                          leading: const SizedBox(),
                          title: Text('Jumlah: ${log.jumlah}',
                              style: const TextStyle(
                                  color: Color(0xFF099AA7),
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text('Total Harga: ${log.totalHarga}',
                              style: const TextStyle(color: Color(0xFF099AA7))),
                        ),
                        ListTile(
                          leading: const SizedBox(),
                          title: Text(
                              'Cabang ${log.transaksi.gudang.cabang.nama}',
                              style: const TextStyle(
                                  color: Color(0xFF099AA7),
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text('Area ${log.inventaris.wilayah.nama}',
                              style: const TextStyle(color: Color(0xFF099AA7))),
                        ),
                        ListTile(
                          leading: const SizedBox(),
                          title: Text('Unit ${log.transaksi.unit.nama}',
                              style: const TextStyle(
                                  color: Color(0xFF099AA7),
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text('Pengguna ${log.inventaris.pengguna}',
                              style: const TextStyle(color: Color(0xFF099AA7))),
                        ),
                        // Add more details as needed
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}