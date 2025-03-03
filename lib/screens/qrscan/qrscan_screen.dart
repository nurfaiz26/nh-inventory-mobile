import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:nh_manajemen_inventory/screens/home/home_screen.dart';
import 'package:nh_manajemen_inventory/screens/inventaris/inventaris_form_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class QrscanScreen extends StatefulWidget {
  const QrscanScreen({super.key});

  @override
  State<QrscanScreen> createState() => _QrscanScreenState();
}

class _QrscanScreenState extends State<QrscanScreen>
    with WidgetsBindingObserver {
  Barcode? _barcode;
  MobileScannerController cameraController = MobileScannerController();
  bool _isVisible = false;
  final TextEditingController kodeController = TextEditingController();

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan QR Code!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return const Text(
      'No display value.',
      overflow: TextOverflow.fade,
      style: TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes, String telepon) async {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });

      // Fetch data from the URL obtained from the QR code
      if (_barcode != null) {
        String url = _barcode!.displayValue ?? '';
        await _fetchData("$url?telepon=$telepon");
      }
    }
  }

  Future<void> _fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parse the JSON data
        final data = json.decode(response.body);

        // Stop the scanner
        cameraController.stop();

        // Navigate to the next screen with the fetched data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InventarisFormScreen(data: data),
          ),
        );
      } else {
        // Handle error
        _showError('Error: Gagal Memuat Data!, Pastikan Kode/QR Sesuai!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      _showError(
          'Error:  Pastikan Scan QR Code Dari Aplikasi Manajemen Inventaris!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void submitKode(String telepon) {
    if (kodeController.text != '') {
      const url = "https://assets.itnh.systems/api/inventaris?kode=";
      _fetchData("$url${kodeController.text}&telepon=$telepon");
    } else {
      _showError('Kode Inventaris Tidak Boleh Kosong!');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Scanner',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF099AA7),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _toggleVisibility,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _isVisible ? 'TUTUP' : 'KODE',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (barcodeCapture) {
              _handleBarcode(barcodeCapture, userData!['telepon']);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
          if (_isVisible) // Conditionally render the component
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withOpacity(0.6),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => _toggleVisibility(),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      const Text(
                        'KODE INVENTARIS',
                        style: TextStyle(
                            color: Color(0xFF099AA7),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          controller: kodeController,
                          decoration: InputDecoration(
                            labelText: 'Kode Inventaris',
                            labelStyle: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            hintText: 'NH 100.01.01.0001',
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            floatingLabelStyle: const TextStyle(
                                color: Color(0xFF099AA7), fontSize: 12),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF099AA7)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xFF099AA7)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Login Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            submitKode(userData!['telepon']);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: const Color(0xFF099AA7),
                            padding: const EdgeInsets.all(4),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
