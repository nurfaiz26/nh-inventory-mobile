import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:nh_manajemen_inventory/screens/inventaris/inventaris_form_screen.dart';

class QrscanScreen extends StatefulWidget {
  const QrscanScreen({super.key});

  @override
  State<QrscanScreen> createState() => _QrscanScreenState();
}

class _QrscanScreenState extends State<QrscanScreen>
    with WidgetsBindingObserver {
  Barcode? _barcode;
  MobileScannerController cameraController = MobileScannerController();

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan QR Code!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });

      // Fetch data from the URL obtained from the QR code
      if (_barcode != null) {
        String url = _barcode!.displayValue ?? '';
        await _fetchData(url);
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
        _showError('Failed to load data');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _handleBarcode,
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
        ],
      ),
    );
  }
}
