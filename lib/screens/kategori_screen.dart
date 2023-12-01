import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'kuis_screen.dart';

class KategoriScreen extends StatefulWidget {
  @override
  _KategoriScreenState createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> daftarKategori = [];

  @override
  void initState() {
    super.initState();
    _loadKategori();
  }

  void _loadKategori() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('kategori').get();

    if (querySnapshot.docs.isNotEmpty) {
      daftarKategori =
          querySnapshot.docs.map((doc) => doc['nama_kategori'] as String).toList();
      setState(() {});
    }
  }

  void _pilihKategori(String selectedCategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KuisScreen(kategori: selectedCategory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Kategori'),
      ),
      body: daftarKategori.isNotEmpty
          ? ListView.builder(
              itemCount: daftarKategori.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(daftarKategori[index]),
                  onTap: () {
                    _pilihKategori(daftarKategori[index]);
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: KategoriScreen(),
  ));
}
