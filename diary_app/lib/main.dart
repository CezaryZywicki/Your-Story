// ignore_for_file: unnecessary_new

import 'package:diary_app/model/Diary.dart';
import 'package:diary_app/screens/get_started_page.dart';
import 'package:diary_app/screens/login_page.dart';
import 'package:diary_app/screens/main_page.dart';
import 'package:diary_app/screens/page_not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final userDiaryDataStream =
      FirebaseFirestore.instance.collection('notes').snapshots().map((diaries) {
    return diaries.docs.map((diary) {
      return Diary.fromDocument(diary);
    }).toList();
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: [])
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Your Story',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.orange,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingsName: settings.name!);
            },
          );
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => PageNotFound(),
        ),
        //home: LoginPage(),
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String settingsName;

  const RouteController({Key? key, required this.settingsName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;
    final signedInGoMain = userSignedIn && settingsName == '/main';
    final notSignedInGoToMain = !userSignedIn && settingsName == '/main';

    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (settingsName == '/main' || notSignedInGoToMain) {
      return LoginPage();
    } else if (settingsName == '/login' || notSignedInGoToMain) {
      return LoginPage();
    } else if (signedInGoMain) {
      return MainPage();
    } else {
      return PageNotFound();
    }
  }
}
