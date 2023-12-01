import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KuisScreen extends StatefulWidget {
  final String kategori;

  KuisScreen({required this.kategori});

  @override
  _KuisScreenState createState() => _KuisScreenState();
}

class _KuisScreenState extends State<KuisScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int currentIndex = 0;
  int totalPoin = 0;
  List<Map<String, dynamic>> daftarKuis = [];
  int selectedOption = -1; // -1 indicates no option selected

  @override
  void initState() {
    super.initState();
    _loadKuis();
  }

  void _loadKuis() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('kuis')
        .where('kategori', isEqualTo: widget.kategori)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      daftarKuis = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {});
    }
  }

  void _jawabKuis(int selectedOption) {
    if (currentIndex < daftarKuis.length) {
      int jawabanBenar = daftarKuis[currentIndex]['jawaban_benar'];

      if (selectedOption == jawabanBenar) {
        totalPoin += 10;
      }

      // Pindah ke pertanyaan berikutnya
      currentIndex++;
      selectedOption = -1; // Reset selected option

      if (currentIndex >= daftarKuis.length) {
        // Kuis selesai
        _tampilkanHasil();
      } else {
        setState(() {});
      }
    }
  }

  void _tampilkanHasil() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hasil Kuis'),
          content: Text('Total Poin: $totalPoin'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kuis - ${widget.kategori}'),
      ),
      body: daftarKuis.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    daftarKuis[currentIndex]['pertanyaan'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Column(
                  children: [
                    for (int i = 1; i <= 4; i++)
                      RadioListTile<int>(
                        title: Text(daftarKuis[currentIndex]['pilihan_$i']),
                        value: i,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedOption != -1) {
                        _jawabKuis(selectedOption);
                      }
                    },
                    child: Text('Jawab'),
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}