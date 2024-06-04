// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app5/Global.dart';
import 'package:app5/pages/BottomNavigationBarExampleApp.dart';
import 'package:app5/pages/allWorkers.dart';
import 'package:app5/pages/categoriesPage.dart';
import 'package:app5/pages/categorySingle.dart';
import 'package:app5/pages/login.dart';
import 'package:app5/pages/searchBar.dart';
import 'package:app5/pages/seearchPage.dart';
import 'package:app5/pages/workerPage.dart';
import 'package:app5/shared/categore.dart';
import 'package:app5/shared/postCategorei.dart';
import 'package:app5/shared/posts.dart';
import 'package:app5/shared/textfield.dart';
import 'package:app5/shared/worker.dart';
import 'package:app5/shared/workerPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePage> {
  List<QueryDocumentSnapshot> dataOfPosts = [];
  List<QueryDocumentSnapshot> dataOfWorks = [];
  List<String> imageLinks = [];
  bool isLoading = true;
  bool isLoadingPost = true;

  @override
  void initState() {
    super.initState();
    getData();
    getDataWorks();
  }

//data of works
  Future<void> getDataWorks() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('work').get();
      setState(() {
        dataOfWorks = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

//the first image of the work
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

//data of posts
  Future<void> getData() async {
    try {
      QuerySnapshot? querySnapshot =
          await FirebaseFirestore.instance.collection('post').get();

      setState(() {
        dataOfPosts = querySnapshot.docs;
        isLoadingPost = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoadingPost = false;
      });
    }
  }

// method to go to the category page
  void goToGategorieSinglePage(int i) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CategorySingle(i: i)));
  }

// methode to refresh
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Bottom()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 127, 127, 211)),
        child: Center(
          child: LiquidPullToRefresh(
            onRefresh: _onRefresh,
            color: Color.fromARGB(255, 127, 127, 211),
            backgroundColor: const Color.fromARGB(255, 246, 245, 245),
            height: 150,
            animSpeedFactor: 2,
            showChildOpacityTransition: false,
            child: ListView(
              children: [
                // the purple layout
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 127, 127, 211),
                  ),
                  width: 1000,
                  height: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0),
                                child: Text(
                                    "Bienvenue ${data.isNotEmpty ? data[0]['name'] : 'Invitée'}👋",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 234, 233, 233),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 3),
                                child: Text(
                                    "C'est une bonne journée pour aider les gens",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 197, 195, 195),
                                    )),
                              ),
                            ],
                          ),
                          
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyTextField(
                        ontap: () {
                          showSearch(
                              context: context,
                              delegate: CostumSearch(dataOfWorks, context));
                        },
                        maybe: true,
                        hiegh: 56,
                        widh: 20,
                        iconnn: Icon(Icons.search_sharp),
                        num: 20,
                        textInputtt: TextInputType.text,
                        isPassword: false,
                        hinttexttt: "Recherche",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                // the works layout
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Catégories populaires',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 13, 13, 13),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoriPage() //here pass the actual values of these variables, for example false if the payment isn't successfull..etc
                                      ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'voir tout',
                                  style: TextStyle(
                                      color: Color.fromARGB(221, 68, 128, 196),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < categoriesData.length; i++)
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => goToGategorieSinglePage(i),
                                      child: Container(
                                        child: Categore(
                                          scale: i % 2 == 0 ? 10 : 20,
                                          name: categoriesData[i]['name']!,
                                          hash: categoriesData[i]['image']!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 5,
                        color: Color.fromARGB(255, 204, 204, 203),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Des ouvriers en feu',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ces gens sont competant nous les recommandons ',
                            style: TextStyle(
                                color: const Color.fromARGB(221, 79, 78, 78),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : dataOfWorks.isEmpty
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
                                  height: 305,
                                  child: ListView.builder(
                                    itemCount: dataOfWorks.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, i) {
                                      final workData = dataOfWorks[i].data();
                                      final String title =
                                          dataOfWorks[i]['title'];
                                      final int price =
                                          dataOfWorks[i]['price'] ;
                                      final String name =
                                          dataOfWorks[i]['name'];
                                      final String description =
                                          dataOfWorks[i]['description'];
                                      final String phone =
                                          dataOfWorks[i]['phone'];
                                      final String category =
                                          dataOfWorks[i]['category'];
                                      final String workId = dataOfWorks[i].id;

                                      return FutureBuilder<String?>(
                                        future: getFirstWorkImage(workId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.waiting ||
                                              !snapshot.hasData) {
                                            // Show loading indicator while fetching image link
                                            return CircularProgressIndicator();
                                          } else {
                                            // Get the fetched image link
                                            final String? imagePath =
                                                snapshot.data;
                                            // Construct WorkerItem with fetched image link
                                            WorkerItem work = WorkerItem(
                                              title: title,
                                              price: price,
                                              UserName: name,
                                              location: 'bouira',
                                              phone: phone,
                                              ImagePath: imagePath!,
                                              description: description,
                                              category: category,
                                            );
                                            // Return GestureDetector with Worker widget
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WorkerPage(
                                                            idWork:
                                                                dataOfWorks[i]
                                                                    ['workId']),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Worker(
                                                    work,
                                                    works: work,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '    ',
                          style: TextStyle(
                              color: const Color.fromARGB(221, 79, 78, 78),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'En cas de problème, dites-nous... ',
                          style: TextStyle(
                              color: const Color.fromARGB(221, 79, 78, 78),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 5,
                        color: Color.fromARGB(255, 204, 204, 203),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Posts ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25.0,
                        ),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Peut-être que tu peux aider ces gens ',
                            style: TextStyle(
                                color: const Color.fromARGB(221, 79, 78, 78),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isLoadingPost
                          ? Center(child: CircularProgressIndicator())
                          : dataOfPosts.isEmpty
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
                                  itemCount: dataOfPosts.length,
                                  itemBuilder: (context, index) => posts(
                                    numberOfPersons: dataOfPosts[index]
                                        ['number'],
                                    id: dataOfPosts[index]['id'],
                                    idPost: dataOfPosts[index].id,
                                    contextt: dataOfPosts[index]['description'],
                                    name: dataOfPosts[index]['name'],
                                    bio:
                                        "Publie par ${dataOfPosts[index]['name']}",
                                    color: Colors.black,
                                    path: dataOfPosts[index]['imageLink'],
                                    postDate: dataOfPosts[index]['timestamp']
                                        .toDate(),
                                  ),
                                )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// this for the search
class CostumSearch extends SearchDelegate {
  BuildContext context;
  List<QueryDocumentSnapshot> dataOfWorks = [];

  CostumSearch(this.dataOfWorks, this.context);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<QueryDocumentSnapshot> matchQuery = [];
    if (dataOfWorks.isNotEmpty) {
      for (var item in dataOfWorks) {
        if (item['title'].toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(item);
        }
      }
    }

    if (matchQuery.isEmpty) {
      return Center(child: Text('Aucun résultat trouvé'));
    } else {
      return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(title: result['title']),
                    ),
                  );
                },
                child: Text(result['title'])),
            // You can add onTap functionality here
          );
        },
      );
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    List<QueryDocumentSnapshot> matchQuery = [];
    if (dataOfWorks.isNotEmpty) {
      for (var item in dataOfWorks) {
        if (item['title'].toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(item);
        }
      }
    }
    if (matchQuery.isEmpty) {
      return Center(child: Text('Aucun résultat trouvé'));
    } else {
      return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result['title']),
            onTap: () {
              // Navigate to search page and pass selected item's data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(title: result['title']),
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  void showResults(BuildContext context) {
    // This method is called when the user submits the query
    // Here, you can navigate to another page passing the query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(title: query),
      ),
    );
  }

  @override
  void onSubmitted(String query) {
    // This method is called when the user submits the query
    // Here, you can navigate to another page passing the query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(title: query),
      ),
    );
  }
}
