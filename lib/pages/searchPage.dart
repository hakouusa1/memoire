// ... other imports ...
import 'package:app5/pages/seearchPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class searchResult extends StatefulWidget {
  searchResult({Key? key}) : super(key: key); // Removed the title property

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<searchResult> {
  List<QueryDocumentSnapshot> searchResults = [];
  bool isLoading = false;

  void search(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        // Adjust the field and collection according to your needs
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('work')
            .where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThanOrEqualTo: query + '\uf8ff')
            .get();

        setState(() {
          searchResults = snapshot.docs;
        });
      } catch (e) {
        // Handle the error, maybe show a Snackbar
      }

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage(title: value,)),
                );
              },
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: search,
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var data = searchResults[index];
                      return ListTile(
                        title:
                            Text(data['name']), // Adjust field names as needed
                        subtitle: Text(data['description']),
                        // Add other list tile properties as needed
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
