// Import necessary packages
import 'package:clima_shield/firebase_options.dart';
import 'package:clima_shield/screens/welcome_screen.dart'; // Import your new welcome screen
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// The main entry point of the app
void main() async {
  // This is required to ensure that Flutter's engine is ready before you run any code that depends on it, like Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  
  // This line connects your app to your Firebase project using the configuration file.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // This runs your application.
  runApp(const MyApp());
}

// This is the root widget of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimaShield', // This is the title of your app
      theme: ThemeData(
        // We can define a consistent theme for the app here
        primarySwatch: Colors.green,
        fontFamily: 'Be Vietnam Pro', // Sets the default font
      ),
      // This removes the little "Debug" banner from the top right corner
      debugShowCheckedModeBanner: false, 
      
      // This sets the WelcomeScreen as the very first screen the user will see.
      home: const WelcomeScreen(),
    );
  }
}