import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/categoriesPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app5/pages/workerPage.dart';
import 'package:app5/shared/worker.dart';
import 'package:app5/shared/workerPost.dart';
import 'package:app5/shared/postCategorei.dart';
import 'package:app5/shared/posts.dart';
import 'package:app5/Global.dart';

class CategorySingle extends StatefulWidget {
  final int i;

  int? a;
  CategorySingle({super.key, required this.i, this.a});

  @override
  _CategorySingleState createState() => _CategorySingleState();
}

class _CategorySingleState extends State<CategorySingle> {
  String currentCategory = 'ALL';

  List<QueryDocumentSnapshot> dataOfWorks = [];
  List<QueryDocumentSnapshot> filteredDataOfWorks = [];
  List<QueryDocumentSnapshot> dataOfPosts = [];
  bool isLoading = true;

  String? selectedLocation;
  int minPrice = 0;
  int maxPrice = 100000;

  @override
  void initState() {
    super.initState();
    getDataWorks();
    getData();
  }

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('post')
        .where('category', isEqualTo: categoriesData[widget.i]['name'])
        .get();

    dataOfPosts = querySnapshot.docs;
    setState(() {});
  }

  getDataWorks() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('work')
          .where('category', isEqualTo: categoriesData[widget.i]['name'])
          .get();
      dataOfWorks = querySnapshot.docs;
      applyFilters();
    } catch (e) {
      print('Error fetching works: $e');
    }
  }

  void applyFilters() {
    filteredDataOfWorks = dataOfWorks.where((doc) {
      int price = doc['price'];
      bool matchesPrice = price >= minPrice && price <= maxPrice;
      bool matchesLocation =
          selectedLocation == null || doc['location'] == selectedLocation;
      return matchesPrice && matchesLocation;
    }).toList();
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
                      value: minPrice.toDouble(),
                      min: 0,
                      max: 100000,
                      divisions: 1000,
                      label: minPrice.toString(),
                      onChanged: (double value) {
                        setState(() {
                          minPrice = value.toInt();
                        });
                      },
                    ),
                  ),
                  Text('\$${minPrice.toString()}'),
                ],
              ),
              Row(
                children: [
                  Text('Max Price:'),
                  Expanded(
                    child: Slider(
                      value: maxPrice.toDouble(),
                      min: 0,
                      max: 100000,
                      divisions: 1000,
                      label: maxPrice.toString(),
                      onChanged: (double value) {
                        setState(() {
                          maxPrice = value.toInt();
                        });
                      },
                    ),
                  ),
                  Text('\$${maxPrice.toString()}'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  applyFilters();
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
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            if (widget.a == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CategoriPage()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Bottom()));
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
              Text(
                categoriesData[widget.i]['name']!,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 15),
              Text(
                categoriesData[widget.i]['descreption']!,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildCategoryButton('ALL'),
                      SizedBox(width: 8),
                      _buildCategoryButton('Posts'),
                      SizedBox(width: 8),
                    ],
                  ),
                  _buildCategoryButton('Filter'),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  if (currentCategory == 'ALL')
                    filteredDataOfWorks.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                child: Image.asset(
                                  "assets/images/noPostYet.png",
                                  width: double.infinity,
                                  height: 250,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filteredDataOfWorks.length,
                            itemBuilder: (context, i) {
                              var imageLinks =
                                  filteredDataOfWorks[i]['imageLinks'];
                              var firstImage = (imageLinks != null &&
                                      imageLinks is List &&
                                      imageLinks.isNotEmpty)
                                  ? imageLinks[0]
                                  : null;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WorkerPage(
                                              a: 1,
                                              i: widget.i,
                                              idWork: filteredDataOfWorks[i]
                                                  ['workId'],
                                            )),
                                  );
                                },
                                child: Post2(
                                  price: filteredDataOfWorks[i]['price'],
                                  description: filteredDataOfWorks[i]
                                      ['description'],
                                  userName: filteredDataOfWorks[i]['name'],
                                  imagePath: firstImage,
                                ),
                              );
                            },
                          ),
                  if (currentCategory == 'Posts')
                    dataOfPosts.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                child: Image.asset(
                                  "assets/images/noPostYet.png",
                                  width: double.infinity,
                                  height: 250,
                                ),
                              ),
                            ],
                          )
                        : Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dataOfPosts.length,
                              itemBuilder: (context, i) {
                                return posts(
                                  idPost: dataOfPosts[i].id,
                                  numberOfPersons: dataOfPosts[i]['number'],
                                  id: dataOfPosts[i]['id'],
                                  contextt: dataOfPosts[i]['description'],
                                  name: dataOfPosts[i]['name'],
                                  bio: "publie par ${dataOfPosts[i]['name']}",
                                  color: Colors.black,
                                  path: dataOfPosts[i]['imageLink'],
                                  postDate:
                                      dataOfPosts[i]['timestamp'].toDate(),
                                );
                              },
                            ),
                          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () {
        if (category == 'Filter') {
          _showFilterSheet();
        } else {
          setState(() {
            currentCategory = category;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: currentCategory == category
              ? Color.fromARGB(255, 65, 101, 127)
              : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          category,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
