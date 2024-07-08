import 'package:aiguru/services/auth/auth_provider.dart';
import 'package:aiguru/services/auth/auth_user.dart';
import 'package:aiguru/services/auth/auth_vertexai.dart';
import 'package:aiguru/services/auth/firebase_auth_provider.dart';


class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  
  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) => provider.createUser(
      email: email, 
      password: password,
      );
  
  @override
  AuthUser? get currentUser => provider.currentUser;
  
  @override
  Future<AuthUser> logIn({
    required String email, 
    required String password,
    }) => provider.logIn(
      email: email, 
      password: password,
      );
  
  @override
  Future<void> logOut() => provider.logOut();
  
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
  
  @override
  Future<void> initialze() => provider.initialze();

 

  @override
  GenAI get currentModel => provider.currentModel;
  
  @override
  NewChat get currentChat => provider.currentChat;
}