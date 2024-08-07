// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'images/splash_pic.jpg',
                fit: BoxFit.cover,
                height: height * .5,
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              'LATEST HEADLINES',
              style: GoogleFonts.anton(
                letterSpacing: .6,
                color: Colors.grey.shade700,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            SpinKitChasingDots(
              size: 40,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
