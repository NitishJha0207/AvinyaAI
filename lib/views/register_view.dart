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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 122, 243, 243),
        title : const Text('Register'),
        centerTitle: true,
        ), 
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email here',
              
                    // 1. Styling the Hint Text
                    hintStyle: TextStyle(
                      color: Colors.grey[400], // Use a subtle gray for the hint
                      fontSize: 16.0,        // Adjust font size for readability 
                    ),
              
                    // 2. Adding a Label
                    labelText: 'Email',        // Clear label for the field
                    labelStyle: const TextStyle(
                      color:  Colors.blue,      // Example color, choose your own theme
                    ),
              
                    // 3. Styling the Border
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      borderSide: const BorderSide(color: Colors.grey), // Customize border color
                    ),
              
                    // 4. Handling Focus State 
                    focusedBorder: OutlineInputBorder( 
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color.fromARGB(255, 122, 243, 243), width: 4.0), // Visual feedback
                    ), 
              
                    // 5. Optional: Adding a Prefix Icon
                    prefixIcon: const Icon(Icons.email, color: Colors.grey), 
              
                    // 6. Content Padding for better spacing
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), 
                ),
              ),
            ),
            // Add Spacing Here
            const SizedBox(height: 10.0), // Adjust the value (20.0) for desired spacing 

            SizedBox(
              width: 300,
              child: TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Enter your password here',
              
                  // 1. Styling the Hint Text
                      hintStyle: TextStyle(
                        color: Colors.grey[400], // Use a subtle gray for the hint
                        fontSize: 16.0,        // Adjust font size for readability 
                      ),
                
                      // 2. Adding a Label
                      labelText: 'Password',        // Clear label for the field
                      labelStyle: const TextStyle(
                        color:  Colors.blue,      // Example color, choose your own theme
                      ),
                
                      // 3. Styling the Border
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        borderSide: const BorderSide(color: Colors.grey), // Customize border color
                      ),
                
                      // 4. Handling Focus State 
                      focusedBorder: OutlineInputBorder( 
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 122, 243, 243), width: 4.0), // Visual feedback
                      ), 
                
                      // 5. Optional: Adding a Prefix Icon
                      prefixIcon: const Icon(Icons.email, color: Colors.grey), 
                
                      // 6. Content Padding for better spacing
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), 
                ),
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
      ),
    );
  }
}