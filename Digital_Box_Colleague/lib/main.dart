// import 'package:flutter/material.dart';
// import 'widgets/login.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Login(),
//       debugShowCheckedModeBanner: false,
//     );
//     // return Login();
//   }
// }


import 'package:flutter/material.dart';

import 'widgets/login.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Baker',
          ),
          primaryTextTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Baker'),
          primaryColor: Color(0xFF0A0E21),
          scaffoldBackgroundColor: Color(0xFF0A0E21),
          appBarTheme: AppBarTheme(
              color: Colors.purple
          )

      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

