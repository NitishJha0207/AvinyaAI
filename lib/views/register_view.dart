import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/services/auth/auth_exceptions.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title : const Text('Register'),), 
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
              try{
                await AuthService.firebase().createUser(
                  email: email, 
                  password: password,
                  );
                  
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
      
              } on WeakPasswordAuthException{
                await showErrorDialog(
                    context, 
                    "You have entered very weak password. Please use combination of a capital letter, small letter, alphanumeric characters for the password.",
                    );
              } on EmailAlreadyInUseAuthException{
                await showErrorDialog(
                    context, 
                    "You are already a registered user. Please log in.",
                    );
              } on InvalidEmailAuthException{
                await showErrorDialog(
                    context, 
                    "Please enter valid email address.",
                    );
              } on GenericAuthException{
                await showErrorDialog(
                    context, 
                    "Failed to register.",
                    );                
              }              
          },
            child: const Text('Register'),
      
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute, 
              (route)=>false,
              );
            }, 
            child: const Text('Already a member? Sign in here!'))
        ],
      ),
    );
  }
}