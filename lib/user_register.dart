import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projectjen/home.dart';
import 'user_login.dart';
import 'login_register_bg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';

class UserRegister extends StatefulWidget {

  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    phoneNumberController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  String? dropdownValue;

  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final confettiController = ConfettiController();

  bool isPlaying = false;

  void signUp() async{
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'Email' : emailController.text,
          'Phone' : phoneNumberController.text,
          'Password' : passwordController.text,
          'Username' : usernameController.text,
          'ProfilePic' : 'https://www.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
          'Role' : dropdownValue.toString(),
        });

        isPlaying = !isPlaying;

        Navigator.pop(context);

        if(isPlaying){
          confettiController.stop();
        }
        else{
          confettiController.play();
        }

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Home()));
      }
      else{
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Colors.pinkAccent,
              title: Text('Password Does Not Match'),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pinkAccent,
          title: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ConfettiWidget(
                confettiController: confettiController,
                blastDirection: pi / 2,
                gravity: 0.01,
              ),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "REGISTER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFe7494b),
                      fontSize: 36
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.email_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              labelText: "Email"
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.phone_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                              labelText: "Phone Number"
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.account_circle_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                              labelText: "Username"
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.password_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: passwordController,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                              labelText: "Password"
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.password_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscuringCharacter: '*',
                          decoration: const InputDecoration(
                              labelText: "Confirm Password"
                          ),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.person_outline_rounded, size: 35, color: Colors.deepOrangeAccent,),
                    SizedBox(
                      width: 300,
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                          value: dropdownValue,
                          isExpanded: true,
                          hint: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Choose your role'),
                          ),
                          items: ['Renter', 'Owner'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  onPressed: signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80.0),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41)
                            ]
                        )
                    ),
                    padding: const EdgeInsets.all(0),
                    child: const Text(
                      "SIGN UP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin()))
                  },
                  child: const Text(
                    "Already Have an Account? Sign in",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFe7494b),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}