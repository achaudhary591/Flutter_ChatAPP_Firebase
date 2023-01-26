import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {

  final TextEditingController _message = TextEditingController();
  final Map<String, dynamic> userMap;
  final String? chatRoomId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatRoom({super.key, required this.userMap, required this.chatRoomId});

  void onSendMessage() async{
    if(_message.text.isNotEmpty){
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser?.displayName,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);

      _message.clear();
    }else{
      print("Enter some text");
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userMap['name'],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.3,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('chatroom')
                    .doc(chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.data != null){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context , index){
                        return Text(snapshot.data!.docs[index]['message']);
                      });
                  }
                  else{
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    SizedBox(
                      height: size.height / 15,
                      width: size.width / 1.28,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: onSendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
