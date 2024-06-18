import 'package:aiguru/firebase_options.dart';
import 'package:aiguru/views/login_view.dart';
import 'package:aiguru/views/register_view.dart';
import 'package:aiguru/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Avinya AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage (),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context)=> const RegisterView(),
      }
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
          
        ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
               final user = FirebaseAuth.instance.currentUser;
               if (user != null) {
                if (user.emailVerified){
                  return const Text('Verified user.');
                } else {
                  return const VerifyEmailView();
                }
               } else {
                return const LoginView();
               }
            default: 
              return const CircularProgressIndicator();
          }
          
        },
      );
  }    
}














