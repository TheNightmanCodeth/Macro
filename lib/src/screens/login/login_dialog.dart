import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginDialog extends StatelessWidget {
  
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _goog = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Column(
        children: <Widget>[
          Positioned(
            top: 50.0,
            width: double.infinity,
            child: Text(
              'Sign-in to Macro',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: FlatButton(
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.google),
                  title: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                color: Colors.amber,
                onPressed: () {
                  _loginWithGoogle(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _loginWithGoogle(context) async {
    final GoogleSignInAccount googleUser = await _goog.signIn();
    final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser currentUser = await _auth.currentUser();
    Navigator.of(context).pop(currentUser.uid == user.uid);
  }
}