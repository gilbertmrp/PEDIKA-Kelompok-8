import 'package:flutter/material.dart';
import 'package:violence_app/dpmdppa/form_report.dart';
import 'package:violence_app/screens/beranda_screen.dart';
import 'package:violence_app/screens/community_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FormReport(),
    );
  }
}
