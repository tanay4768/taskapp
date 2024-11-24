import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outtaskapp/provider/task_provider.dart';
import 'package:outtaskapp/view/temprory_task_screen.dart';
import 'package:provider/provider.dart';
import 'provider/compulsorytask_provider.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.get("today") == null ){
    prefs.setString("today", DateTime.timestamp().millisecondsSinceEpoch.toString());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>TemprorytaskProvider()),
    ChangeNotifierProvider(create: (context) => CompulsoryTaskProvider()),
    ],
      child: MaterialApp(
        home: TaskScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

