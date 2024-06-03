import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/workerPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app5/shared/postCategorei.dart';
import 'package:app5/shared/posts.dart';
import 'package:app5/shared/worker.dart';
import 'package:app5/shared/workerPost.dart';
import 'package:app5/Global.dart';

import 'homePageMethod.dart';

class SearchPage extends StatefulWidget {
  final String title;

  SearchPage({Key? key, required this.title}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String currentPage = 'ALL';
  List<QueryDocumentSnapshot> dataOfWorks = [];
  List<QueryDocumentSnapshot> dataOfPosts = [];
  bool isLoading = true;
  String? selectedLocation;
  double minPrice = 0;
  double maxPrice = 1000;

  @override
  void initState() {
    super.initState();
    getDataWorks();
    getData();
  }

  Future<String?> getFirstWorkImage(String workId) async {
    try {
      final DocumentSnapshot workSnapshot =
          await FirebaseFirestore.instance.collection('work').doc(workId).get();

      // Check if the document exists
      if (!workSnapshot.exists) {
        return null; // Document does not exist
      }

      final dynamic data = workSnapshot.data();
      // Check if the 'imageLinks' field exists and is a list
      if (data != null && data['imageLinks'] is List<dynamic>) {
        final List<dynamic> imageLinks = data['imageLinks'];
        if (imageLinks.isNotEmpty) {
          return imageLinks[0].toString();
        }
      }

      // If 'imageLinks' field is not found or empty
      return null;
    } catch (e) {
      print('Error getting work images: $e');
      return null;
    }
  }

  Future<void> getDataWorks() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('work')
          .where('title', isGreaterThanOrEqualTo: widget.title)
          .where('title', isLessThanOrEqualTo: widget.title + '\uf8ff')
          .get();
      dataOfWorks = querySnapshot.docs; // Update dataOfWorks directly
    } catch (e) {
      print('Error fetching works: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getDataFilterWork() async {
    setState(() {
      isLoading = true;
    });
    try {
      Query query = FirebaseFirestore.instance
          .collection('work')
          .where('title', isGreaterThanOrEqualTo: widget.title)
          .where('title', isLessThanOrEqualTo: widget.title + '\uf8ff')
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice);

      if (selectedLocation != null) {
        query = query.where('location', isEqualTo: selectedLocation);
      }

      QuerySnapshot querySnapshot = await query.get();
      dataOfWorks = querySnapshot.docs; // Update dataOfWorks directly
    } catch (e) {
      print('Error fetching works: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('post')
          .where('description', isGreaterThanOrEqualTo: widget.title)
          .where('description', isLessThanOrEqualTo: widget.title + '\uf8ff')
          .get();
      dataOfPosts = querySnapshot.docs; // Update dataOfPosts directly
    } catch (e) {
      print('Error fetching posts: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                hint: Text('Select Location'),
                value: selectedLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue;
                  });
                },
                items: <String>[
                  'Adrar',
                  'Chlef',
                  'Laghouat',
                  'Oum El Bouaghi',
                  'Batna',
                  'Béjaïa',
                  'Biskra',
                  'Béchar',
                  'Blida',
                  'Bouira',
                  'Tamanrasset',
                  'Tébessa',
                  'Tlemcen',
                  'Tiaret',
                  'Tizi Ouzou',
                  'Algiers',
                  'Djelfa',
                  'Jijel',
                  'Sétif',
                  'Saïda',
                  'Skikda',
                  'Sidi Bel Abbès',
                  'Annaba',
                  'Guelma',
                  'Constantine',
                  'Médéa',
                  'Mostaganem',
                  'M\'Sila',
                  'Mascara',
                  'Ouargla',
                  'Oran',
                  'El Bayadh',
                  'Illizi',
                  'Bordj Bou Arréridj',
                  'Boumerdès',
                  'El Tarf',
                  'Tindouf',
                  'Tissemsilt',
                  'El Oued',
                  'Khenchela',
                  'Souk Ahras',
                  'Tipaza',
                  'Mila',
                  'Aïn Defla',
                  'Naâma',
                  'Aïn Témouchent',
                  'Ghardaïa',
                  'Relizane'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Text('Min Price:'),
                  Expanded(
                    child: Slider(
                      value: minPrice,
                      min: 0,
                      max: 100000,
                      divisions: 100,
                      label: minPrice.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          minPrice = value;
                        });
                      },
                    ),
                  ),
                  Text('\$${minPrice.round()}'),
                ],
              ),
              Row(
                children: [
                  Text('Max Price:'),
                  Expanded(
                    child: Slider(
                      value: maxPrice,
                      min: 0,
                      max: 1000,
                      divisions: 100,
                      label: maxPrice.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          maxPrice = value;
                        });
                      },
                    ),
                  ),
                  Text('\$${maxPrice.round()}'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  getDataFilterWork();
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 243, 243),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Bottom()),
              );
            }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CostumSearch(dataOfWorks, context));
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('Results of | ${widget.title} |',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              SizedBox(height: 15),
              Text("we wish that can help you"),
              SizedBox(height: 15),
              _buildCategoryButtons(),
              SizedBox(height: 10),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildCategoryButton('ALL'),
            SizedBox(
              width: 10,
              ),
              _buildCategoryButton('Posts'),
          ],
        ),
        _buildCategoryButton('Filter'),
      ],
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () {
        if (category == 'Filter') {
          _showFilterSheet();
        } else {
          setState(() => currentPage = category);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: currentPage == category
              ? Color.fromARGB(255, 65, 101, 127)
              : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(category, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: [
          if (currentPage == 'ALL') _buildAllContent(),
          if (currentPage == 'Posts') _buildPostsContent(),
        ],
      );
    }
  }

  Widget _buildAllContent() {
    return dataOfWorks.isEmpty
        ? _buildEmptyContent()
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataOfWorks.length,
            itemBuilder: (context, index) {
              return FutureBuilder<String?>(
                future: getFirstWorkImage(dataOfWorks[index].id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  String? firstImage = snapshot.data;
                  return GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => WorkerPage(
                                  a: 0,
                                  idWork: dataOfWorks[index]['workId'],
                                ))),
                    child: Post2(
                      price: dataOfWorks[index]['price'],
                      description: dataOfWorks[index]['title'],
                      userName: dataOfWorks[index]['name'],
                      imagePath: firstImage ?? '', // Show the first image
                    ),
                  );
                },
              );
            },
          );
  }

  Widget _buildPostsContent() {
    return dataOfPosts.isEmpty
        ? _buildEmptyContent()
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataOfPosts.length,
            itemBuilder: (context, index) => posts(
              numberOfPersons: 10,
              id: dataOfPosts[index]['id'],
              contextt: dataOfPosts[index]['description'],
              name: dataOfPosts[index]['name'],
              bio: "Publie par ${dataOfPosts[index]['name']}",
              color: Colors.black,
              path: dataOfPosts[index]['imageLink'],
              postDate: dataOfPosts[index]['timestamp'],
              idPost: dataOfPosts[index].id,
            ),
          );
  }

  Widget _buildEmptyContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          child: Image.asset("assets/images/noPostYet.png",
              width: double.infinity, height: 250),
        ),
      ],
    );
  }
}
