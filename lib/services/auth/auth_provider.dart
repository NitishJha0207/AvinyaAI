import 'package:aiguru/services/auth/auth_user.dart';
import 'package:aiguru/services/auth/auth_vertexai.dart';

abstract class AuthProvider{
  Future<void> initialze();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password, 
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
  GenAI get currentModel;
  NewChat get currentChat;
  Future<void> handleSignIn();
  
}



