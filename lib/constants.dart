import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:videozen/views/screens/auth/home_screen.dart';
import 'controllers/auth_controllers.dart';

const pages = [
  Text("home"),
  Text("Search"),
  Text("Add page screen"),
  Text("Messages"),
  Text("Profile"),
];
// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.white;
var secondaryColor = Colors.greenAccent;
const borderColor = Colors.grey;

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

var authController = AuthController.instance;
