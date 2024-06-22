import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/views/login_view.dart';
import 'package:aiguru/views/mainui_view.dart';
import 'package:aiguru/views/register_view.dart';
import 'package:aiguru/views/verify_email_view.dart';
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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context)=> const RegisterView(),
        mainuiRoute: (context)=> const MainView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      }
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialze(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
               final user = AuthService.firebase().currentUser;
               if (user != null) {
                if (user.isEmailVerified){
                  return const MainView();
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











