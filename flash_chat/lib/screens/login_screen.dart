import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Component/snackbar.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Component/our_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, pass;
  bool status = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: status,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextBoxDecoration.copyWith(hintText: 'Enter your e-mail'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  pass = value;
                },
                decoration: kTextBoxDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              OurButton(
                text: 'Login',
                color: Colors.lightBlueAccent,
                onPress: () async {
                  setState(() {
                    status = true;
                  });
                  try {
                    final log = await _auth.signInWithEmailAndPassword(
                        email: email, password: pass);
                    if (log != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        status = false;
                      });
                    }
                  } catch (e) {
                    print('hi');
                    if (e.toString().contains('invalid')) {
                       setState(() {
                        status = false;
                      });
                      showSnackBar('Entered password is invalid', context);
                    }
                    if (e.toString().contains('no user')) {
                       setState(() {
                        status = false;
                      });
                      showSnackBar('User does not exist', context);
                    }
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
