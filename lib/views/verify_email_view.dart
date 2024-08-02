import 'package:aiguru/constants/routes.dart';
import 'package:aiguru/services/auth/auth_service.dart';
import 'package:aiguru/utilities/show_error_dialog.dart';
import 'package:aiguru/utilities/show_message_dialog.dart';
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 122, 243, 243),
        title: const Text('Verify Email'),
        centerTitle: true,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const Text("Please verify your email address by clicking on the verification link sent to your registered email address."),
            //const Text("You may press the button below if you have not received the link."),
            //TextButton(
            //  onPressed: () async{            
            //  await AuthService.firebase().sendEmailVerification();
            //  await showMessageDialog(context, "Verification link sent to your registered email ID.");
            //},
            //child: const Text('Send email verification'),
            //),
            const SizedBox(height: 30), // Add spacing from the top

                // Title Text 
                const Text(
                  "Verify Your Email", // More concise and impactful title
                  textAlign: TextAlign.center,
                  style: TextStyle(                    
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue
                  ),
                  
                ),

                const SizedBox(height: 20), // Spacing 

                // Instruction Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding
                  child: Text(
                    "Please verify your email address by clicking on the link sent to your registered email address.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      ),
                  ),
                ),

                const SizedBox(height: 10), // Spacing

                // Resend Link Option
                TextButton(
                  onPressed: () async {
                    await AuthService.firebase().sendEmailVerification();
                    await showMessageDialog(
                        context, "Verification link sent to your registered email ID.");
                  },
                  child: const Text(
                    "Resend Verification Link", // Clearer action 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Customize color as needed
                    ),
                  ),
                ),
            TextButton(
              onPressed: () async{
               await AuthService.firebase().logOut();
               Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute, 
                (route)=> false,
                );
              }, 
              child: const Text(
                'Login',
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Customize color as needed
                    ),
                ),
            ),
        
          ],
          ),
      ),
    );
  }
}