// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Commetpage extends StatefulWidget {
  String postId;
  Commetpage({required this.postId});

  @override
  _CommetpageState createState() => _CommetpageState();
}

class _CommetpageState extends State<Commetpage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  // Remove the filedata list as it's no longer needed
  // List filedata = [];

  Future<void> getComments() async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Retrieve comments from Firestore
      QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postId)
          .collection('comments')
          .orderBy('date', descending: true)
          .get();

      // Update the UI
      setState(() {});
    } catch (error) {
      print('Error retrieving comments: $error');
    }
  }

  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  // Remove dataComments list as it's not used
  // List<QueryDocumentSnapshot> dataComments = [];

  // Build method and other widget code...

  @override
  void initState() {
    getData();
    getComments(); // Get comments on initialization
    super.initState();
  }

  bool onReply = false;
  int? replyingToIndex;

  Widget replyChild(List<dynamic> replies) {
    return Column(
      children: [
        for (var i = 0; i < replies.length; i++)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: CommentBox.commentImageParser(
                        imageURLorPath: replies[i]['pic'],
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              replies[i]['name'],
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 10),
                            Text(replies[i]['date'],
                                style: TextStyle(fontSize: 10)),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              replies[i]['message'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 14, 14, 14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.favorite_outline,
                          size: 19,
                        ),
                        onPressed: () {}),
                    Text(
                      '0',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          )
      ],
    );
  }

  Widget commentChild(QuerySnapshot commentsSnapshot) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: commentsSnapshot.docs.length,
      itemBuilder: (context, index) {
        var commentData =
            commentsSnapshot.docs[index].data() as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: commentData['pic'],
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                commentData['name'],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 10),
                              Text(commentData['date'],
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                commentData['message'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 14, 14, 14)),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  onReply = !onReply;
                                  replyingToIndex = index;
                                });
                              },
                              child: Text(
                                "reply",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 87, 87, 87)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.favorite_outline,
                            size: 19,
                          ),
                          onPressed: () {}),
                      Text(
                        '0',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
              replyChild(commentData['replies']),
              if (onReply && replyingToIndex == index)
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          decoration: InputDecoration(
                            hintText: 'Write a reply...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (replyController.text.isNotEmpty) {
                            setState(() {
                              // Add reply to Firestore
                              FirebaseFirestore.instance
                                  .collection('post')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('comments')
                                  .doc(commentsSnapshot.docs[index].id)
                                  .update({
                                'replies': FieldValue.arrayUnion([
                                  {
                                    'name': data.isEmpty
                                        ? 'Anonymous'
                                        : data[0]['name'],
                                    'pic': data.isEmpty
                                        ? 'assets/images/sad2.jpg'
                                        : data[0]['imageLink'],
                                    'message': replyController.text,
                                    'date': DateTime.now().toIso8601String()
                                  }
                                ])
                              });
                              replyController.clear();
                              onReply = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Page"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 247, 245, 245),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(widget.postId)
            .collection('comments')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            child: CommentBox(
              userImage: CommentBox.commentImageParser(
                imageURLorPath: data.isNotEmpty
                    ? data[0]['imageLink'] ?? 'assets/images/sad2.jpg'
                    : 'assets/images/sad2.jpg',
              ),
              child: commentChild(snapshot.data!),
              labelText: 'Write a comment...',
              errorText: 'Comment cannot be blank',
              withBorder: false,
              sendButtonMethod: () {
                if (formKey.currentState!.validate()) {
                  print(commentController.text);
                  setState(() {
                    postComment(
                        commentController.text); // Post the comment to Firebase
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  });
                  commentController.clear();
                  FocusScope.of(context).unfocus();
                } else {
                  print("Not validated");
                }
              },
              formKey: formKey,
              commentController: commentController,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              textColor: const Color.fromARGB(255, 37, 37, 37),
              sendWidget: Icon(Icons.send_sharp,
                  size: 30, color: Color.fromARGB(255, 15, 15, 15)),
            ),
          );
        },
      ),
    );
  }

  Future<void> postComment(String comment) async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the current date and time
      String currentDate = DateTime.now().toIso8601String();

      // Add the comment to Firestore
      await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'name': data.isNotEmpty ? data[0]['name'] : 'Anonymous',
        'pic':
            data.isNotEmpty ? data[0]['imageLink'] : 'assets/images/sad2.jpg',
        'message': comment,
        'date': currentDate,
        'replies': [], // Initialize replies list
      });

      // Refresh the comments
      await getComments();
    } catch (error) {
      print('Error posting comment: $error');
    }
  }
}
