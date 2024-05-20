import 'package:chat/constents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/Textfield.dart';
import '../widgets/containerbutton.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // to store the variable which in text field
  String? email;

  String? password;

  // key of the form
  GlobalKey<FormState> formkey = GlobalKey();

  bool Loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Loading,
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Image.asset("scholar.png"),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Schooler Chat",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // wrap with row to make at start of line of page.
                  Row(
                    children: [
                      Text("Register",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextfieldLogin(
                    onchange: (data) {
                      email = data;
                    },
                    TextHint: "Email",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextfieldLogin(
                    // i send it as constractor to textfield widget
                    onchange: (data) {
                      // data is the char i will type in text field
                      password = data;
                    },
                    TextHint: "Password",
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  // button of register
                  GestureDetector(
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          Loading = true;
                        });
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: email!, password: password!);
                          // succes
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Registeration is Done Succefully"),
                            backgroundColor: Colors.green,
                          ));
                          Navigator.pushNamed(context, "ChatPage");
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("There was an erro weak password"),
                              backgroundColor: Colors.red,
                            ));
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "There was an error email already exist"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("There was an erroe Please try again"),
                            backgroundColor: Colors.red,
                          ));
                        }

                        // after try and catch if success

                        setState(() {
                          Loading = false;
                        });
                      }
                    },
                    child: buttoncontainer(
                        text: "Register", butcolor: Colors.white),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "already have an account?  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
