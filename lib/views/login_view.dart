
import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email, 
                password: password
                );
                Navigator.of(context).  pushNamedAndRemoveUntil(
                  mainuiRoute, 
                  (route) => false ,
                  );
              } 
              on FirebaseAuthException catch(e){
                if (e.code== 'invalid-credential'){
                  await showErrorDialog(
                    context, 
                    "Please check your credentials. Either you have entered incorrect username/password or You are not a registered user.",
                    );
                  devtools.log("User not found");
                } else if (e.code  == "wrong-password"){
                  await showErrorDialog(
                    context, 
                    "You have entered incorrect password.",
                    );
                } else {
                  await showErrorDialog(
                    context, 
                    'Error: ${e.code}',
                    );
                }
              } catch (e) {
                  await showErrorDialog(
                    context, 
                    e.toString(),
                    );
              }
              
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute, 
                (route)=>false,
                );
            }, 
            child: const Text("Not registered yet? Register here!"),
            )
        ],
      ),
    );
  }     
}


