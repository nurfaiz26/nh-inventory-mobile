import 'dart:convert';

import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'
    show MediaType; // Import for MediaType

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nh_manajemen_inventory/models/Merk.dart';
import 'package:nh_manajemen_inventory/models/Seri.dart';
import 'package:nh_manajemen_inventory/models/Unit.dart';
import 'package:nh_manajemen_inventory/models/Wilayah.dart';
import 'package:nh_manajemen_inventory/models/inventaris.dart';
import 'package:nh_manajemen_inventory/models/log_inventaris_perawatan.dart';
import 'package:nh_manajemen_inventory/models/perawatan.dart';
import 'package:nh_manajemen_inventory/models/yayasan.dart';
import 'package:nh_manajemen_inventory/providers/auth_provider.dart';
import 'package:nh_manajemen_inventory/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

List<Merk> fetchMerks(dynamic data) {
  final List<dynamic> jsonList = data['merks'];
  return jsonList.map((json) => Merk.fromJson(json)).toList();
}

List<Seri> fetchSeris(dynamic data) {
  final List<dynamic> jsonList = data['seris'];
  return jsonList.map((json) => Seri.fromJson(json)).toList();
}

List<Unit> fetchUnits(dynamic data) {
  final List<dynamic> jsonList = data['units'];
  return jsonList.map((json) => Unit.fromJson(json)).toList();
}

List<Wilayah> fetchWilayah(dynamic data) {
  final List<dynamic> jsonList = data['wilayahs'];
  return jsonList.map((json) => Wilayah.fromJson(json)).toList();
}

class InventarisFormScreen extends StatefulWidget {
  final dynamic data;
  const InventarisFormScreen({super.key, required this.data});

  @override
  State<InventarisFormScreen> createState() => _InventarisFormScreenState();
}

class _InventarisFormScreenState extends State<InventarisFormScreen> {
  late List<Merk> merks;
  late List<Seri> seris;
  late List<Unit> units;
  late List<Wilayah> wilayahs;
  late Inventaris inventaris;
  late Yayasan yayasan;
  File? foto;
  late DateTime currentDateTime;
  late DateTime yesterday;
  late DateTime endOfToday;
  late dynamic data;
  final _formKey = GlobalKey<FormState>();

  List<Merk> filteredMerks = [];
  List<Seri> filteredSeris = [];
  List<Unit> filteredUnits = [];
  List<Wilayah> filteredWilayahs = [];

  TextEditingController penggunaController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  // TextEditingController merkController = TextEditingController();
  // TextEditingController seriController = TextEditingController();
  TextEditingController wilayahController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController keteranganMetaController = TextEditingController();

  void filterMerk(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredMerks = merks
            .where(
                (data) => data.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredMerks = [];
      });
    }
  }

  void filterSeri(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredSeris = seris
            .where(
                (data) => data.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredSeris = [];
      });
    }
  }

  void filterUnit(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredUnits = units
            .where(
                (data) => data.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredUnits = [];
      });
    }
  }

  void filterWilayah(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredWilayahs = wilayahs
            .where(
                (data) => data.nama.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredWilayahs = [];
      });
    }
  }

  void clearFilteredData() {
    setState(() {
      // filteredMerks.clear();
      // filteredSeris.clear();
      filteredUnits.clear();
      filteredWilayahs.clear();
    });
  }

  Future<void> _fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parse the JSON data
        final resdata = json.decode(response.body);

        setState(() {
          data = resdata;

          merks = fetchMerks(data);
          seris = fetchSeris(data);
          units = fetchUnits(data);
          wilayahs = fetchWilayah(data);
          inventaris = Inventaris.fromJson(data['data']['inventaris']);
          yayasan = Yayasan.fromJson(data['data']['yayasan']);

          penggunaController.text = inventaris.pengguna;
          statusController.text = inventaris.status;
          // merkController.text = inventaris.merk.nama;
          // seriController.text = inventaris.seri.nama;
          wilayahController.text = inventaris.wilayah.nama;
          unitController.text = inventaris.unit.nama;
          keteranganMetaController.text = inventaris.keterangan ?? '';

          currentDateTime = DateTime.now();
          yesterday = DateTime(currentDateTime.year, currentDateTime.month,
              currentDateTime.day - 1);
          endOfToday = DateTime(currentDateTime.year, currentDateTime.month,
              currentDateTime.day + 1);
        });
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Gagal Memuat Data!)')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Gagal Memuat Data!)')));
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        foto = File(pickedFile.path);
      });
    }
  }

  Future<void> postData(String idInventaris, String telepon) async {
    // Create a multipart request
    final uri = Uri.parse(
        'https://assets.itnh.systems/api/inventaris/$idInventaris'); // Replace with your API endpoint
    final request = http.MultipartRequest('POST', uri);
    request.headers['Content-Type'] = 'multipart/form-data';

    if (penggunaController.text == '' ||
        // merkController.text == '' ||
        // seriController.text == '' ||
        unitController.text == '' ||
        wilayahController.text == '' ||
        statusController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Tidak Lengkap"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      return;
    }

    if (statusController.text == 'nonaktif' &&
        keteranganController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Keterangan Harus Terisi!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      return;
    }

    if (foto != null) {
      // Compress the image
      final img.Image? originalImage =
          img.decodeImage(await foto!.readAsBytes());
      final img.Image compressedImage = img.copyResize(originalImage!,
          width: 800); // Resize to width of 800 pixels

      // Convert the compressed image back to bytes
      final List<int> compressedBytes = img.encodeJpg(compressedImage,
          quality: 50); // Adjust quality as needed

      request.files.add(http.MultipartFile.fromBytes(
        'foto', // The name of the field in the API
        compressedBytes,
        filename: 'image.jpg', // The name of the file
        contentType:
            MediaType('image', 'jpeg'), // Adjust content type as needed
      ));
    }

    // Add text field
    request.fields["pengguna"] = penggunaController.text;
    // request.fields["merk"] = merkController.text;
    // request.fields["seri"] = seriController.text;
    request.fields["unit"] = unitController.text;
    request.fields["wilayah"] = wilayahController.text;
    request.fields["status"] = statusController.text;
    request.fields["telepon"] = telepon;
    if (keteranganController.text != '') {
      request.fields["keterangan"] = keteranganController.text;
    }

    // Send the request
    final response = await request.send();

    final responseData = await response.stream.bytesToString();

    print(request.files);
    print(responseData);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Inventaris Berhasil Diupdate"),
          backgroundColor: Color(0xFF099AA7),
          duration: Duration(seconds: 3),
        ),
      );

      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              // '${responseData.toString()}, '
              'Pastikan Isi Input Sesuai Dengan Pilihan Yang Tersedia!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> deletePerawatan(
      int id, String kodeInventaris, String telepon) async {
    String baseUrl = "https://assets.itnh.systems/api";
    final response = await http.delete(
      Uri.parse('$baseUrl/perawatan/$id'),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Inventaris Berhasil Diupdate"),
          backgroundColor: Color(0xFF099AA7),
          duration: Duration(seconds: 3),
        ),
      );

      await _fetchData(
          "https://assets.itnh.systems/api/inventaris?kode=$kodeInventaris&telepon=$telepon");

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              // '${responseData.toString()}, '
              'Hapus Gagal!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _showConfirmationDialog(String idInventaris, String telepon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Update',
            style: TextStyle(
                color: Color(0xFF099AA7), fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Semua update akan tercatat beserta informasi peng-update! Lanjutkan?',
            style: TextStyle(
              color: Color(0xFF099AA7),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                // Handle form submission
                postData(idInventaris, telepon);

                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  String formatToIndonesian(double number) {
    // Create a NumberFormat for Indonesian locale
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 2,
    );
    return "Rp. ${formatter.format(number)}";
  }

  @override
  void initState() {
    super.initState();

    data = widget.data;

    merks = fetchMerks(data);
    seris = fetchSeris(data);
    units = fetchUnits(data);
    wilayahs = fetchWilayah(data);
    inventaris = Inventaris.fromJson(data['data']['inventaris']);
    yayasan = Yayasan.fromJson(data['data']['yayasan']);

    penggunaController.text = inventaris.pengguna;
    statusController.text = inventaris.status;
    // merkController.text = inventaris.merk.nama;
    // seriController.text = inventaris.seri.nama;
    wilayahController.text = inventaris.wilayah.nama;
    unitController.text = inventaris.unit.nama;
    keteranganMetaController.text = inventaris.keterangan ?? '';

    currentDateTime = DateTime.now();
    yesterday = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day - 1);
    endOfToday = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day + 1);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return GestureDetector(
      onTap: () {
        // Clear filtered data when tapping outside the TextField
        clearFilteredData();
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Inventaris ${inventaris.kode}',
            style: const TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: const Color(0xFF099AA7),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Image.network(
                  inventaris.foto != null
                      ? 'https://assets.itnh.systems/folder-image-inventaris/${inventaris.foto}'
                      : '',
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Center(
                      child: Text(
                        'Gambar Inventaris Gagal Dimuat/Tidak Ada',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Barang', inventaris.barang.item.nama),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Merk', inventaris.merk.nama),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Seri', inventaris.seri.nama),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Yayasan', yayasan.nama),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Gudang', inventaris.barang.gudang.nama),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Cabang', inventaris.barang.gudang.cabang.nama),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Penyusutan', inventaris.penyusutan + ' Bulan'),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Nilai Awal',
                  formatToIndonesian(double.parse(inventaris.nilaiAwal))),
              const SizedBox(
                height: 10,
              ),
              metaDataText(
                  'Akumulasi Susut',
                  formatToIndonesian(
                      double.parse(data['data']['akumulasi_susut']))),
              const SizedBox(
                height: 10,
              ),
              metaDataText(
                  'Nilai Susut',
                  formatToIndonesian(
                      double.parse(data['data']['nilai_susut']))),
              const SizedBox(
                height: 10,
              ),
              metaDataText('Nilai Buku',
                  formatToIndonesian(double.parse(data['data']['nilai_buku']))),
              const SizedBox(
                height: 20,
              ),
              if (keteranganMetaController.text != '')
                textAreaTextField(keteranganMetaController, "Keterangan", true),
              if (keteranganMetaController.text != '')
                const SizedBox(
                  height: 20,
                ),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFF099AA7), width: 2))),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        color: Color(0xFF099AA7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF099AA7),
                          width: 2,
                        ),
                      )),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              updateFormTextField(
                penggunaController,
                inventaris.status == "nonaktif" ? false : true,
                'Pengguna',
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // updateFormSelectTextField(merkController, 'Merk', merks,
                      //     filteredMerks, filterMerk),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // updateFormSelectTextField(seriController, 'Seri', seris,
                      //     filteredSeris, filterSeri),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      updateFormSelectTextField(
                          unitController,
                          'Unit/Divisi',
                          units,
                          filteredUnits,
                          inventaris.status == "nonaktif" ? false : true,
                          filterUnit),
                      const SizedBox(
                        height: 10,
                      ),
                      updateFormSelectTextField(
                          wilayahController,
                          'Area',
                          wilayahs,
                          filteredWilayahs,
                          inventaris.status == "nonaktif" ? false : true,
                          filterWilayah),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Status',
                          style: TextStyle(
                              color: Color(0xFF099AA7),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          updateFormRadionButton('aktif',
                              inventaris.status == "nonaktif" ? false : true),
                          InkWell(
                            onTap: inventaris.status == "aktif"
                                ? () {
                                    setState(() {
                                      statusController.text = 'aktif';
                                    });
                                  }
                                : null,
                            child: Text(
                              'Aktif',
                              style: TextStyle(
                                  color: statusController.text == 'aktif'
                                      ? const Color(0xFF099AA7)
                                      : Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          updateFormRadionButton('nonaktif',
                              inventaris.status == "nonaktif" ? false : true),
                          InkWell(
                            onTap: inventaris.status == "aktif"
                                ? () {
                                    setState(() {
                                      statusController.text = 'nonaktif';
                                    });
                                  }
                                : null,
                            child: Text(
                              'Non Aktif',
                              style: TextStyle(
                                  color: statusController.text == 'nonaktif'
                                      ? const Color(0xFF099AA7)
                                      : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      textAreaTextField(
                          keteranganController,
                          "Keterangan (Wajib Saat Non Aktif)",
                          inventaris.status == "nonaktif" ? true : false),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      // updateFormSelectList(
                      //     merkController, merks, filteredMerks),
                      // const SizedBox(
                      //   height: 70,
                      // ),
                      // updateFormSelectList(
                      //     seriController, seris, filteredSeris),
                      // const SizedBox(
                      //   height: 70,
                      // ),
                      updateFormSelectList(
                          unitController, units, filteredUnits),
                      const SizedBox(
                        height: 70,
                      ),
                      updateFormSelectList(
                          wilayahController, wilayahs, filteredWilayahs),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Gambar (Opsional)',
                      style: TextStyle(
                          color: Color(0xFF099AA7),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  if (foto != null) const SizedBox(height: 10),
                  if (foto != null)
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.file(
                        foto!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: const Color(0xFF099AA7),
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: inventaris.status == "aktif"
                              ? () => _pickImage(ImageSource.camera)
                              : null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Ambil Foto',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: const Color(0xFF099AA7),
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: inventaris.status == "aktif"
                              ? () => _pickImage(ImageSource.gallery)
                              : null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Pilih Foto',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: const Color(0xFF099AA7),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: inventaris.status == "aktif"
                      ? () => _showConfirmationDialog(
                          inventaris.id.toString(), userData!['telepon'])
                      : null,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.update,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inventaris.kartuPerawatan != null
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFF099AA7),
                                            width: 2))),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'KARTU PERAWATAN',
                                style: TextStyle(
                                  color: Color(0xFF099AA7),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF099AA7),
                                    width: 2,
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            Text(
                              'List Inventaris',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Color(0xFF099AA7),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        for (int i = 0;
                            i <
                                inventaris.kartuPerawatan!
                                    .logInvetarisPerawatan!.length;
                            i++)
                          Column(
                            children: [
                              inventarisExpansionTile(inventaris
                                  .kartuPerawatan!.logInvetarisPerawatan![i]),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Color(0xFF099AA7)))),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        const Row(
                          children: [
                            Text(
                              'List Perawatan',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Color(0xFF099AA7),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (inventaris.kartuPerawatan?.perawatans != null)
                          for (int i = 0;
                              i < inventaris.kartuPerawatan!.perawatans!.length;
                              i++)
                            Column(
                              children: [
                                perawatanTile(
                                    inventaris.kartuPerawatan!.perawatans![i],
                                    userData),
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Color(0xFF099AA7)))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        const Row(
                          children: [
                            Text(
                              'Form Perawatan',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Color(0xFF099AA7),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        updateFormTextField(
                          penggunaController,
                          inventaris.status == "nonaktif" ? false : true,
                          'Tanggal',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        updateFormSelectTextField(
                            wilayahController,
                            'Jenis Perawatan',
                            wilayahs,
                            filteredWilayahs,
                            inventaris.status == "nonaktif" ? false : true,
                            filterWilayah),
                        const SizedBox(
                          height: 20,
                        ),
                        textAreaTextField(
                            keteranganController,
                            "Keterangan Perawatan",
                            inventaris.status == "nonaktif" ? true : false),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: const Color(0xFF099AA7),
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: inventaris.status == "aktif"
                                ? () => _showConfirmationDialog(
                                inventaris.id.toString(), userData!['telepon'])
                                : null,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.post_add,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Submit Perawatan',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget metaDataText(String title, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF099AA7),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Color(0xFF099AA7),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color(0xFF099AA7), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget updateFormTextField(
      TextEditingController controller, bool isEnabled, String label) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Color(0xFF099AA7)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF099AA7)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF099AA7)),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget updateFormSelectTextField(
      TextEditingController controller,
      String label,
      List data,
      List filteredData,
      bool isEnabled,
      Function(String query) changeHandler) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      onChanged: changeHandler,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Color(0xFF099AA7)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF099AA7)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF099AA7)),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget textAreaTextField(
      TextEditingController controller, String label, bool isEnbaled) {
    return TextField(
      controller: controller,
      maxLines: null,
      readOnly: isEnbaled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Color(0xFF099AA7)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF099AA7)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF099AA7)),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget updateFormSelectList(
      TextEditingController controller, List data, List filteredData) {
    double height =
        filteredData.isNotEmpty ? (60 * filteredData.length).toDouble() : 0;

    if (height > 200) {
      height = 200;
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
                color: Colors.grey,
              ),
              child: Text(
                filteredData[index].nama,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              controller.text =
                  filteredData[index].nama.toString().toUpperCase();
              clearFilteredData();
            },
            onTapCancel: () {
              clearFilteredData();
            },
          );
        },
      ),
    );
  }

  Widget updateFormRadionButton(String value, bool isEnabled) {
    return Radio(
      splashRadius: 0,
      activeColor: const Color(0xFF099AA7),
      value: value,
      groupValue: statusController.text,
      onChanged: isEnabled
          ? (String? value) {
              setState(() {
                statusController.text = value!;
              });
            }
          : null,
    );
  }

  Widget inventarisExpansionTile(LogInventarisPerawatan logInventaris) {
    return ExpansionTile(
      title: Text(logInventaris.inventarisPerawatan.kode,
          style: const TextStyle(
              color: Color(0xFF099AA7), fontWeight: FontWeight.bold)),
      subtitle: Text(
        logInventaris.inventarisPerawatan.barang.item.nama,
        style: const TextStyle(color: Color(0xFF099AA7)),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_down,
        color: Color(0xFF099AA7),
      ),
      children: [
        ListTile(
          leading: const SizedBox(),
          title: Text('Merk: ${logInventaris.inventarisPerawatan.merk.nama}',
              style: const TextStyle(
                  color: Color(0xFF099AA7), fontWeight: FontWeight.bold)),
        ),
        ListTile(
          leading: const SizedBox(),
          title: Text('Seri ${logInventaris.inventarisPerawatan.seri.nama}',
              style: const TextStyle(
                  color: Color(0xFF099AA7), fontWeight: FontWeight.bold)),
        ),
        ListTile(
          leading: const SizedBox(),
          title: Text('Status: ${logInventaris.status.toUpperCase()}',
              style: TextStyle(
                  color: inventaris.status == 'aktif'
                      ? const Color(0xFF099AA7)
                      : Colors.red,
                  fontWeight: FontWeight.bold)),
        ),
        // Add more details as needed
      ],
    );
  }

  Widget perawatanTile(Perawatan perawatan, dynamic userData) {
    return ExpansionTile(
      title: Text(perawatan.keterangan ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Color(0xFF099AA7), fontWeight: FontWeight.w500)),
      leading: DateFormat("dd-MM-yyyy")
                  .parse(perawatan.createdAt ?? DateTime(1900, 1, 1).toString())
                  .isAfter(yesterday) &&
              DateFormat("dd-MM-yyyy")
                  .parse(perawatan.createdAt ?? DateTime(1900, 1, 1).toString())
                  .isBefore(endOfToday)
          ? IconButton(
              onPressed: DateFormat("dd-MM-yyyy")
                          .parse(perawatan.createdAt ?? DateTime(1900, 1, 1).toString())
                          .isAfter(yesterday) &&
                      DateFormat("dd-MM-yyyy")
                          .parse(perawatan.createdAt ?? DateTime(1900, 1, 1).toString())
                          .isBefore(endOfToday)
                  ? () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Konfirmasi Delete',
                                style: TextStyle(
                                    color: Color(0xFF099AA7),
                                    fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                'Data perewatan ini akan dihapus! Lanjutkan?',
                                style: TextStyle(
                                  color: Color(0xFF099AA7),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel',
                                      style: TextStyle(color: Colors.green)),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Hapus',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    // Handle form submission
                                    deletePerawatan(perawatan.id,
                                        inventaris.kode, userData['telepon']);

                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    }
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  : null,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ))
          : null,
      children: [
        ListTile(
          title: Text(perawatan.keterangan ?? '',
              style: const TextStyle(
                  color: Color(0xFF099AA7), fontWeight: FontWeight.w500)),
          subtitle:
              Text('${perawatan.createdAt} | ${perawatan.jenisPerawatan != null ? perawatan.jenisPerawatan!.nama : '--'}',
                  style: const TextStyle(
                    color: Color(0xFF099AA7),
                  )),
        ),
      ],
    );
  }
}
