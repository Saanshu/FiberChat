import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';
import 'package:flutter_application_1/screens/chatroom.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Map<String, dynamic> userMap;
  Map<String, dynamic> userMap2;
  Map<String, dynamic> chatMap;
  var showList = true;
  var backbutton = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();
  bool isLoading = false;
  String chatRoomId(String user1, String user2) {
    List room = [user1, user2];
    room.sort();
    if (room[0] == user1) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _firestore
          .collection('users')
          .where('username', isEqualTo: _search.text)
          .get()
          .then((value) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });
      });
      await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser.email)
          .get()
          .then((value) {
        setState(() {
          userMap2 = value.docs[0].data();
          isLoading = false;
        });
      });
    } catch (err) {
      var message = 'Invalid Username.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Chat'),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _auth.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AuthScreen()));
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: backbutton
                          ? () => Navigator.of(context)
                              .pushReplacementNamed('/search')
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.blue,
                    ),
                    Container(
                      width: 296,
                      child: TextField(
                        controller: _search,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            hintText: 'Enter Username',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0))),
                      ),
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () {
                              onSearch();
                              setState(() {
                                showList = false;
                                backbutton = true;
                              });
                            },
                            icon: const Icon(Icons.search),
                            color: Colors.blue,
                          ),
                  ],
                ),
              ),
              userMap != null
                  ? ListTile(
                      onTap: () {
                        String roomId =
                            chatRoomId(userMap2['email'], userMap['email']);
                        print(userMap2['email']);
                        print(userMap['email']);
                        print(roomId);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ChatRoom(
                                chatRoomId: roomId, userMap: userMap)));
                      },
                      leading: const Icon(
                        Icons.person_outlined,
                        color: Colors.orange,
                        size: 30,
                      ),
                      title: Text(
                        userMap['username'],
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(userMap['email']),
                      trailing: const Icon(
                        Icons.chat_bubble,
                        color: Colors.green,
                        size: 20,
                      ),
                    )
                  : Container(),
              showList
                  ? StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('users')
                          .orderBy('username')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return SingleChildScrollView(
                            child: Container(
                              height: 700,
                              width: 500,
                              child: ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> map =
                                        snapshot.data.docs[index].data();
                                    return map['email'] !=
                                            _auth.currentUser.email
                                        ? ListTile(
                                            onTap: () {
                                              String roomId = chatRoomId(
                                                  map['email'],
                                                  _auth.currentUser.email);
                                              chatMap = snapshot.data.docs[index].data();
        
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) => ChatRoom(
                                                          chatRoomId: roomId,
                                                          userMap: chatMap)));
                                            },
                                            leading: const Icon(
                                              Icons.person_outlined,
                                              color: Colors.orange,
                                              size: 30,
                                            ),
                                            title: Text(
                                              map['username'],
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(map['email']),
                                            trailing: const Icon(
                                              Icons.chat_bubble,
                                              color: Colors.lightGreen,
                                              size: 20,
                                            ),
                                          )
                                        : Container();
                                  }),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      })
                  : Container(),
            ],
          )),
        ));
  }
}
