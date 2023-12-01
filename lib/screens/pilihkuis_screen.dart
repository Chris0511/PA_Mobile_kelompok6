import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PilihKuisScreen extends StatefulWidget {
  const PilihKuisScreen({Key? key}) : super(key: key);

  @override
  _PilihKuisScreenState createState() => _PilihKuisScreenState();
}

class _PilihKuisScreenState extends State<PilihKuisScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> quizzes = [];
  List<Map<String, dynamic>> filteredQuizzes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Call a function to fetch and display quizzes during initState
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    // Fetch categories from Firestore
    final QuerySnapshot categorySnapshot =
        await _firestore.collection('kuis').get();

    List<Map<String, dynamic>> retrievedQuizzes = [];

    for (QueryDocumentSnapshot categoryDocument in categorySnapshot.docs) {
      String categoryId = categoryDocument.id;

      // Fetch quizzes from the subcollection of each category
      final QuerySnapshot quizSnapshot = await _firestore
          .collection('kuis/$categoryId/Pertanyaan')
          .get(); // No need for $Pertanyaanid

      for (QueryDocumentSnapshot quizDocument in quizSnapshot.docs) {
        Map<String, dynamic> data = quizDocument.data() as Map<String, dynamic>;

        // Include the document ID and category name in the quiz data
        data['documentId'] = quizDocument.id;
        data['kategori'] = await getCategoryName(categoryId);

        retrievedQuizzes.add(data);
      }
    }

    setState(() {
      quizzes = retrievedQuizzes;
      filteredQuizzes = quizzes; // Initialize filteredQuizzes with all quizzes initially
    });
  }

  Future<String> getCategoryName(String categoryId) async {
    // Fetch category name from Firestore based on category ID
    final DocumentSnapshot categoryDoc =
        await _firestore.doc('kuis/$categoryId').get();
    if (categoryDoc.exists) {
      return categoryDoc.get('Kategori') ?? 'Kategori Tidak Diketahui';
    } else {
      return 'Kategori Tidak Diketahui';
    }
  }

  void _filterQuizzes(String query) {
    setState(() {
      filteredQuizzes = quizzes
          .where((quiz) =>
              quiz['pertanyaan'].toLowerCase().contains(query.toLowerCase()) ||
              quiz['kategori'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Kuis'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final String? selected = await showSearch(
                context: context,
                delegate: QuizSearchDelegate(quizzes),
              );

              if (selected != null && selected.isNotEmpty) {
                // Handle the selected quiz, navigate, or perform any other action
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kuis yang Ingin Dikerjakan:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // TextFormFiled for search query
              TextField(
                controller: _searchController,
                onChanged: _filterQuizzes,
                decoration: InputDecoration(
                  labelText: 'Cari Kuis',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterQuizzes('');
                    },
                  ),
                ),
              ),

              SizedBox(height: 16),
              
              // Display quizzes for selection
              if (filteredQuizzes.isNotEmpty)
                Column(
                  children: filteredQuizzes
                      .map(
                        (quizData) => Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            title: Text(quizData['pertanyaan']),
                            subtitle: Text('Kategori: ${quizData['kategori']}'),
                            onTap: () {
                              // Navigate to the screen where the selected quiz can be worked on
                            },
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                Text('Belum ada kuis yang tersedia.'),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> quizzes;

  QuizSearchDelegate(this.quizzes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<Map<String, dynamic>> filteredList = quizzes
        .where((quiz) =>
            quiz['pertanyaan'].toLowerCase().contains(query.toLowerCase()) ||
            quiz['kategori'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final quiz = filteredList[index];
        return ListTile(
          title: Text(quiz['pertanyaan']),
          subtitle: Text('Kategori: ${quiz['kategori']}'),
          onTap: () {
            // Handle the selected quiz, navigate, or perform any other action
            close(context, quiz['pertanyaan']);
          },
        );
      },
    );
  }
}
