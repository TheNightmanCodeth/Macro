////
/// This file provides util methods for accessing the firebase 
/// It contains Classes for all of the fb functions we will use
/// These include:
///   * Cloud Firestore (Database)
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firebase {

  FirebaseApp app;

  Future<Firebase> init() async {
    Firebase fb;
  }
}

class Item {
    String key;
    String title;
    String body;

    Item(this.title, this.body);

    Item.fromSnapshot(DataSnapshot snapshot)
        : key = snapshot.key,
          title = snapshot.value["title"],
          body = snapshot.value["body"];

    toJson() {
      return {
        "title": title,
        "body": body;
      }
    }
  }