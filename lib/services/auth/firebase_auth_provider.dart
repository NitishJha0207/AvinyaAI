import 'package:aiguru/firebase_options.dart';
import 'package:aiguru/services/auth/auth_user.dart';
import 'package:aiguru/services/auth/auth_provider.dart';
import 'package:aiguru/services/auth/auth_exceptions.dart';
import 'package:aiguru/services/auth/auth_vertexai.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


/// The scopes required by this application.
// #docregion Initialize
const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

Future<void> _handleSignOut() => _googleSignIn.disconnect();

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
  }) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, 
        password: password,
        );
        final user = currentUser;
        if (user != null){
          return user;
        } else {
          throw UserNotLoggedInAuthException();
        }
    } on FirebaseAuthException catch(e) {
       if (e.code == 'weak-password'){
        throw WeakPasswordAuthException();
          }else if (e.code == 'email-already-in-use'){
            throw EmailAlreadyInUseAuthException();
          }else if (e.code == 'invalid-email'){
            throw InvalidEmailAuthException();
          } else {
            throw GenericAuthException();
          }
      
    } catch (_) {
      throw GenericAuthException(); 
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      return AuthUser.fromFirebase(user);
      
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email, 
    required String password,
    })  async { 
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, 
          password: password,
          );
          final user = currentUser;
          if (user != null) {
            return user;
          } else {
            throw UserNotLoggedInAuthException();
          }
      } 
              on FirebaseAuthException catch(e){
                if (e.code== 'invalid-credential'){
                  throw UserNotFoundAuthException();
                } else if (e.code  == "wrong-password"){
                  throw WrongPasswordAuthException();
                } else {
                  throw GenericAuthException();
                }
              } catch (e) {
                throw GenericAuthException();
              }
  }

  @override
  Future<void> logOut() async {
    

    final user  = FirebaseAuth.instance.currentUser;
    if (user != null){
      const ElevatedButton(
            onPressed: _handleSignOut,
            child: Text('SIGN OUT'),
          );
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
  
  @override
  Future<void> initialze() async {
    await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,          
        );
    
    // Initialize the Vertex AI service and the generative model
    // Specify a model that supports your use case
    // Gemini 1.5 models are versatile and can be used with all API capabilities
    
  }
  
  @override
  GenAI get currentModel => currentModel;
  
  @override
  NewChat get currentChat => currentChat;
  
  

  
  
  @override
  Future<void> handleSignIn() async {
  const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
   ];
  final GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: 'your-client_id.apps.googleusercontent.com',
    scopes: scopes,
  );
  try {
    await googleSignIn.signIn();
  } catch (error) {
    //print(error);
  }
}


  

}