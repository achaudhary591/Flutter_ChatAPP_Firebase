import 'package:chat_app_firebase/chat_room.dart';
import 'package:chat_app_firebase/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = false;
  Map<String, dynamic> userMap = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? chatRoomId(String? user1, String? user2){
    if(user1![0].toLowerCase().codeUnits[0] > user2![0].toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }else{
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    TextEditingController _search = TextEditingController();

    void onSearch() async{

      FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

      isLoading = true;

      await _firebaseFirestore.collection('users').where("email", isEqualTo: _search.text).get().then((value) {
        setState(() {
          userMap = value.docs[0].data();
          isLoading = false;
        });
        print(userMap);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () => logOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
        centerTitle: true,
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : Column(
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.centerLeft,
            child: Center(
              child: SizedBox(
                height: size.height / 14,
                width: size.width / 1.2,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          ElevatedButton(
            onPressed: onSearch,
            child: const Text(
              'Search'
            )
          ),
          SizedBox(
            height: size.height / 30,
          ),
          userMap.isNotEmpty ?
          ListTile(
            onTap: () {
              String? roomId = chatRoomId(_auth.currentUser?.displayName, userMap['name']);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatRoom(
                chatRoomId: roomId,
                userMap: userMap,
              )));
            },
            leading: const Icon(Icons.account_box, color: Colors.black,),
            title: Text(
              userMap['name'],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            subtitle: Text(userMap['email']),
            trailing: const Icon(Icons.chat, color: Colors.black,),
          ) :
          Container(),
        ],
      ),
    );
  }
}
