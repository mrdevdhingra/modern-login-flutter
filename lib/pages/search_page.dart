import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {


  String? currentUserId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
  final queryLowerCase = query.toLowerCase();
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('username', isGreaterThanOrEqualTo: queryLowerCase)
      .where('username', isLessThan: queryLowerCase + '\uf8ff')
      .get();

  return querySnapshot.docs
      .map((doc) => {
            'id': doc.id, // Include the document ID
            ...doc.data(),
          })
      .toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search for users...',
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(child: Text('Enter a search query'))
                : FutureBuilder<List<Map<String, dynamic>>>(
                    future: searchUsers(_searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data!.isEmpty) {
                        return Center(child: Text('No users found'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final user = snapshot.data![index];
                            return ListTile(
                              title: Text(user['username']??'unknown'),
                              subtitle: Text(user['email']),
                              trailing: IconButton(
                                icon: Icon(Icons.person_add),
                                onPressed: 
                                  () async {
    if (currentUserId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('friends')
            .doc(user['id'])
            .set({
          'uid': user['id'],
          'firstname': user['first name'],
          'secondname': user['second name'],
          'email': user['email'],
          'age': user['username'],
        });

        // Show a success message using a SnackBar
        final snackBar = SnackBar(
          content: Text('User added as a friend'),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        // Show an error message using a SnackBar
        final snackBar = SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      // Handle the case when the user is not signed in or their ID is not available
      final snackBar = SnackBar(
        content: Text('Error: User not signed in'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
