import 'package:chat_app_firebase/login_screen.dart';
import 'package:chat_app_firebase/methods.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: isLoading? const Center(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ): SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: size.width / 1.2,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              SizedBox(
                width: size.width / 1.1,
                child: const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: size.width / 1.1,
                child: Text(
                  'Create Account In to Continue!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, 'Name', Icons.account_box, _name)
                ),
              ),
              Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: field(size, 'Email', Icons.account_box, _email)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: field(size, 'Password', Icons.lock, _password),
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              customButton(size),
              SizedBox(
                height: size.height / 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton(Size size){
    return GestureDetector(
      onTap: (){
        if(_name.text.isNotEmpty && _email.text.isNotEmpty && _password.text.isNotEmpty){
          setState(() {
            isLoading = true;
          });
          createAccount(_name.text, _email.text, _password.text).then((user) {
            if(user != null){
              setState(() {
                isLoading = false;
              });
              print("Account Created Successfully");
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            }else{
              setState(() {
                isLoading = false;
              });
              print("Account Creation Failed");
            }
          });
        }
        else{
          print("Please Enter all the Fields");
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: const Text(
          'Create Account',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),

        ),
      ),
    );
  }

  Widget field(Size size , String hintText , IconData icon, TextEditingController controller){
    return SizedBox(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
