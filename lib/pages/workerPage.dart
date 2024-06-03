import 'package:app5/pages/categoriesPage.dart';
import 'package:app5/pages/categorySingle.dart';
import 'package:app5/pages/seearchPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'DemandForm.dart';
import 'package:url_launcher/url_launcher.dart';

import 'NeedServe.dart';

class WorkerPage extends StatefulWidget {
  final String idWork;
  final int? a;
  final int? i;
  WorkerPage({Key? key, required this.idWork, this.a, this.i}) : super(key: key);

  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  List<QueryDocumentSnapshot> dataOfWorks = [];
  bool isLoading = true;
  PageController _pageController = PageController();
  int _currentImageIndex = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    getDataWorks();
  }

  List<QueryDocumentSnapshot> data = [];

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: auth.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  Future<void> getDataWorks() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('work')
          .where('workId', isEqualTo: widget.idWork)
          .limit(1) // Limit the query to 1 document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          dataOfWorks = querySnapshot.docs; // Store the list of documents
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Work data not found')));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch work data: $e')));
      }
    }
  }

  // Other methods remain unchanged

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 127, 127, 211),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            if (widget.a == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SearchPage(title: dataOfWorks[0]['title']),
                ),
              );
            }else if(widget.a == 1){
              Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CategorySingle(i: widget.i!)));
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text("Worker Details", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }

  Widget buildContent() {
    if (dataOfWorks.isEmpty) {
      return Center(
          child: Text("No data available", style: TextStyle(fontSize: 18)));
    }

    var currentData = dataOfWorks[0];
    var imageLinks = List<String>.from(currentData['imageLinks'] ?? []);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImageSlider(imageLinks),
          SizedBox(height: 20),
          buildThumbnailRow(imageLinks),
          SizedBox(height: 20),
          Text(currentData['title'] ?? '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(currentData['description'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          SizedBox(height: 20),
          buildActionButtons(currentData),
          SizedBox(height: 20),
          buildCommentSection(currentData.id), // Add comment section
        ],
      ),
    );
  }

  Widget buildImageSlider(List<String> imageLinks) {
    return Container(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: imageLinks.isNotEmpty ? imageLinks.length : 1,
        onPageChanged: (index) {
          setState(() {
            _currentImageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: imageLinks.isNotEmpty
                    ? NetworkImage(imageLinks[index])
                    : AssetImage('assets/images/default.jpg') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildThumbnailRow(List<String> imageLinks) {
    if (imageLinks.isEmpty)
      return Container(child: Text('No images available'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('All Images:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(imageLinks.length, (index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _currentImageIndex == index
                        ? Color.fromARGB(255, 127, 127, 211)
                        : Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageLinks[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildActionButtons(QueryDocumentSnapshot currentData) {
    String phoneNumber = currentData['phone'] ?? '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            if (phoneNumber.isNotEmpty) {
              launch("tel:$phoneNumber");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Phone number not available')));
            }
          },
          icon: Icon(Icons.call),
          label: Text("Call"),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DemandForm(
                  workid: currentData['id'],
                  postId: currentData.id,
                ),
              ),
            );
          },
          icon: Icon(Icons.add),
          label: Text("Make a Demand"),
        ),
      ],
    );
  }

  Widget buildCommentSection(String workId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments:',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black54)),
        SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('work')
              .doc(workId)
              .collection('comments')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var comments = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                var commentData = comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: commentData['imageLink'] != null
                        ? NetworkImage(commentData['imageLink'])
                        : AssetImage('assets/images/sad2.jpg') as ImageProvider,
                  ),
                  title: Row(
                    children: [
                      Text(
                        commentData['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: 8), // Add spacing between name and comment
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(commentData['comment']),
                      SizedBox(height: 4),
                      Text(
                        commentData['timestamp'] != null
                            ? DateFormat('yyyy-MM-dd – kk:mm').format(
                                (commentData['timestamp'] as Timestamp)
                                    .toDate())
                            : '',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Enter your comment',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  addComment(workId, _commentController.text);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> addComment(String workId, String comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('work')
          .doc(workId)
          .collection('comments')
          .add({
        'imageLink': data[0]['imageLink'],
        'name': data[0]['name'],
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add comment: $e')));
    }
  }
}
