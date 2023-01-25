import 'package:chat_app_firebase/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = false;
  Map<String, dynamic> userMap = {};

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
              child: Container(
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
        ],
      ),
    );
  }

  Widget chatTile(){

  }
}
