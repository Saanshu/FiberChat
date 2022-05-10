import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_screen.dart';

class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({this.chatRoomId, this.userMap});

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
    void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = { 
        "sendby": _auth.currentUser.email,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _auth.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AuthScreen()));
                })
          ],
        
        title: Text(userMap['username']),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: userMap['sendby'] == _auth.currentUser.email
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
              height: 680,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                  .collection('chatroom')
                  .doc(chatRoomId)
                  .collection('chats')
                  .orderBy('time',descending: true)
                  .snapshots(),
                builder: (
                BuildContext context,
                AsyncSnapshot <QuerySnapshot> snapshot){
                  if (snapshot.data != null){
                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          Map<String, dynamic> map =
                              snapshot.data.docs[index].data();
                          return messages(map);
                        }
                        );
                  }else {
                    return Container(
                      height: 0,
                    );
                  }
        
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
            width: 340,
                  child: TextField(
                    controller: _message,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        hintText: "Send Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.send), onPressed: onSendMessage),
              ]
            )
          ],
        ),
      ),
      
    );
  }
  Widget messages( Map<String, dynamic> map) {
    return Container(
      width: 100,
      alignment: map['sendby'] == _auth.currentUser.email
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: map['sendby'] == _auth.currentUser.email
          ? BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(0),
                      ),
                    ):
                    BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
        child: Text(
          map['message'],
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

}
