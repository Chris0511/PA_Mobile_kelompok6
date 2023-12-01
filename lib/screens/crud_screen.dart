import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizz_app/ui/shared/color.dart';

import '../function/hapus_kuis.dart';

void main() {
  runApp(MaterialApp(
    home: CrudScreen(),
  ));
}

class CrudScreen extends StatefulWidget {
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedCategoryId = 'CKviJamgfcoeUo6MLEsU'; // Set default category
  TextEditingController pertanyaanController = TextEditingController();
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  TextEditingController jawabanController = TextEditingController();

  List<Map<String, dynamic>> categories = [];
  List<String> kuisOptions = [];
  List<Map<String, dynamic>> quizzes = [];
  bool isEditMode = false;
  String? selectedQuizDocumentId;

  Future<void> _readQuizzes() async {
    String kategoriId = selectedCategoryId ?? '';

    final QuerySnapshot snapshot =
        await _firestore.collection('kuis/$kategoriId/Pertanyaan').get();

    List<Map<String, dynamic>> retrievedQuizzes = [];

    for (QueryDocumentSnapshot document in snapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // Include the document ID in the quiz data
      data['documentId'] = document.id;

      retrievedQuizzes.add(data);
    }

    setState(() {
      quizzes = retrievedQuizzes;
    });
  }

  void tambahKuis() async {
    String kategoriId = selectedCategoryId ?? '';

    try {
      if (isEditMode) {
        // Update the quiz if in edit mode
        // Use the selected quiz document ID for updating
        await _firestore
            .collection('kuis/$kategoriId/Pertanyaan')
            .doc(selectedQuizDocumentId)
            .update({
          'pertanyaan': pertanyaanController.text,
          'option1': option1Controller.text,
          'option2': option2Controller.text,
          'option3': option3Controller.text,
          'option4': option4Controller.text,
          'jawaban_benar': int.parse(jawabanController.text),
        });

        // Reset edit mode and selectedQuizDocumentId after successful update
        setState(() {
          isEditMode = false;
          selectedQuizDocumentId = null;
        });
      } else {
        // Add a new quiz if not in edit mode
        DocumentReference documentReference =
            await _firestore.collection('kuis/$kategoriId/Pertanyaan').add({
          'pertanyaan': pertanyaanController.text,
          'option1': option1Controller.text,
          'option2': option2Controller.text,
          'option3': option3Controller.text,
          'option4': option4Controller.text,
          'jawaban_benar': int.parse(jawabanController.text),
        });

        // Get the newly added quiz document and include its ID in the local state
        DocumentSnapshot documentSnapshot = await documentReference.get();
        Map<String, dynamic> newQuizData =
            documentSnapshot.data() as Map<String, dynamic>;
        newQuizData['documentId'] = documentSnapshot.id;

        // Update the local state to include the new quiz
        setState(() {
          quizzes.add(newQuizData);
        });
      }

      // Show pop-up dialog on successful save
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Berhasil simpan kuis.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear the text controllers after a successful save
      pertanyaanController.clear();
      option1Controller.clear();
      option2Controller.clear();
      option3Controller.clear();
      option4Controller.clear();
      jawabanController.clear();
    } catch (error) {
      // Handle the error (e.g., show another dialog)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Isi semua data kuis!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Call _readQuizzes during initState to display quizzes on the initial load
    _readQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Buat Kuis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Kategori',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: selectedCategoryId,
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value;
                          // Call _readQuizzes when the category changes
                          _readQuizzes();
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: 'CKviJamgfcoeUo6MLEsU',
                          child: Text('Sejarah Indonesia'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'IBy8A9TRTAGJgihsmIwp',
                          child: Text('Sejarah Dunia'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Kiq8G6XxZTn5OPGrhHGr',
                          child: Text('Olahraga'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'bt03KdDXfMPrFUrqHuMo',
                          child: Text('Teknologi'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'hm7GtIfsbYLjXPffZsRG',
                          child: Text('Seni Budaya'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Input Kuis',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: kuisOptions
                          .map(
                            (option) => RadioListTile<String>(
                              title: Text(option),
                              value: option,
                              groupValue: selectedCategoryId,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategoryId = value;
                                  // Call _readQuizzes when the category changes
                                  _readQuizzes();
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 16),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          TextFormField(
                            controller: pertanyaanController,
                            decoration: InputDecoration(
                              labelText: 'Pertanyaan',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: option1Controller,
                            decoration: InputDecoration(
                              labelText: 'Pilihan 1(indeks 0)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: option2Controller,
                            decoration: InputDecoration(
                              labelText: 'Pilihan 2(indeks 1)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: option3Controller,
                            decoration: InputDecoration(
                              labelText: 'Pilihan 3(indeks 2)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: option4Controller,
                            decoration: InputDecoration(
                              labelText: 'Pilihan 4(indeks 3)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: jawabanController,
                            decoration: InputDecoration(
                              labelText: 'Jawaban Benar (indeks)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              tambahKuis();
                            },
                            child: Text('Simpan Kuis'),
                          ),
                          SizedBox(height: 16),

                          // Display retrieved quizzes
                          if (quizzes.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Semua Kuis:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Display individual quiz items with delete and update buttons
                                  for (Map<String, dynamic> quizData in quizzes)
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      margin: EdgeInsets.only(bottom: 8.0),
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Pertanyaan: ${quizData['pertanyaan']}\n'
                                              'Indeks 0: ${quizData['option1']}\n'
                                              'Indeks 1: ${quizData['option2']}\n'
                                              'Indeks 2: ${quizData['option3']}\n'
                                              'Indeks 3: ${quizData['option4']}\n'
                                              'Jawaban(indeks): ${quizData['jawaban_benar']}',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  // Set edit mode to true
                                                  setState(() {
                                                    isEditMode = true;
                                                    // Populate text form fields with quiz data
                                                    selectedQuizDocumentId =
                                                        quizData['documentId'];
                                                    pertanyaanController.text =
                                                        quizData['pertanyaan'];
                                                    option1Controller.text =
                                                        quizData['option1'];
                                                    option2Controller.text =
                                                        quizData['option2'];
                                                    option3Controller.text =
                                                        quizData['option3'];
                                                    option4Controller.text =
                                                        quizData['option4'];
                                                    jawabanController.text =
                                                        quizData[
                                                                'jawaban_benar']
                                                            .toString();
                                                  });
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  // Call the function to delete quiz
                                                  hapusKuis(
                                                      context,
                                                      quizData['documentId'],
                                                      selectedCategoryId!,
                                                      quizzes,
                                                      (updatedQuizzes) {
                                                    setState(() {
                                                      quizzes = updatedQuizzes;
                                                    });
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
