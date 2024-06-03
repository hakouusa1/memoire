import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:app5/pages/CommetsPage.dart';
import '../pages/SetDemandPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class posts extends StatefulWidget {
  const posts({
    Key? key,
    required this.path,
    required this.name,
    required this.bio,
    this.color,
    required this.contextt,
    required this.postDate,
    required this.id,
    required this.numberOfPersons,
    required this.idPost,
  });

  final String contextt;
  final String path;
  final String name;
  final String bio;
  final Color? color;
  final String id;
  final DateTime postDate;
  final int numberOfPersons;
  final String idPost;

  @override
  State<posts> createState() => _PostsState();
}

class _PostsState extends State<posts> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
  }

  Future<void> _checkLikeStatus() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.idPost)
          .get();
      setState(() {
        if (doc.data() != null) {
          final likes = doc.data()!['likes'] as List<dynamic>?;
          isLiked = likes != null && likes.contains(user.uid);
          likeCount = doc.data()!['likesCount'] ?? 0;
        }
      });
    }
  }

  Future<void> _toggleLike() async {
    final user = auth.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('post')
          .doc(widget.idPost);

      if (isLiked) {
        // Remove like
        await docRef.update({
          'likes': FieldValue.arrayRemove([user.uid]),
          'likesCount': FieldValue.increment(-1),
        });
        setState(() {
          isLiked = false;
          likeCount--;
        });
      } else {
        // Add like
        await docRef.update({
          'likes': FieldValue.arrayUnion([user.uid]),
          'likesCount': FieldValue.increment(1),
        });
        setState(() {
          isLiked = true;
          likeCount++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate time difference
    Duration difference = DateTime.now().difference(widget.postDate);

    String timeAgo = '';

    // Calculate time ago
    if (difference.inDays > 0) {
      timeAgo =
      '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      timeAgo =
      '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      timeAgo =
      '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      timeAgo = 'Just now';
    }

    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundImage: Image.network(widget.path).image,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                Text(
                  widget.numberOfPersons > 0
                      ? '${widget.numberOfPersons} persons'
                      : '✔️',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  widget.bio,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "( $timeAgo )",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.contextt,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 29, 28, 28),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width - 30,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _toggleLike,
                    icon: Icon(
                      isLiked ? Iconsax.heart : Iconsax.heart_copy,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      '$likeCount',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    useSafeArea: true,
                    context: context,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.9, // 90% of the screen height
                        child: Commetpage(postId: widget.idPost),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Setdemandpage(
                        postId: widget.id,
                        realIdPost: widget.idPost,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "send OFFRE",
                  style: TextStyle(
                      color: Color.fromARGB(255, 12, 95, 178), fontSize: 18),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 5,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
