import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column(
        children: [
          const Text("Please verify your email address by clicking on the verification link sent to your registered email address."),
          const Text("You may press the button below if you have not received the link."),
          TextButton(
            onPressed: () async{            
            await AuthService.firebase().sendEmailVerification();
          },
          child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async{
             await AuthService.firebase().logOut();
             Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute, 
              (route)=> false,
              );
            }, 
            child: const Text('Restart'),
          ),
      
        ],
        ),
    );
  }
}