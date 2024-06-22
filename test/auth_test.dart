import 'package:aiguru/services/auth/auth_exceptions.dart';
import 'package:aiguru/services/auth/auth_provider.dart';
import 'package:aiguru/services/auth/auth_user.dart';
import 'package:test/test.dart';


void main(){
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialiazed to begin with', () {
      expect(provider.isInitialzed, false);
    });

    test('Cannot log out if not initialized', (){
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to initialized', () async {
      await provider.initialze();
      expect(provider.isInitialzed, true);
    });

    test('Should be null after initialization', (){
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialze();
      expect(provider.isInitialzed, true);
    }, timeout: const Timeout(Duration(seconds: 2)),
    );


    test('Create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com', 
        password: 'anypassword',
      ); 

      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
      email: 'someone@bar.com', 
      password: 'foobar',
      );

      expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo', 
        password: 'bar',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });  
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider{
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialzed => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) async {
      if(!isInitialzed) throw NotInitializedException();
      await Future.delayed(const Duration(seconds: 1));
      return logIn(
        email: email, 
        password: password,
        );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialze() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email, 
    required String password,
    }) {
      if(!isInitialzed) throw NotInitializedException();
      if (email == "foo@bar.com") throw UserNotFoundAuthException();
      if (password == 'foobar') throw WrongPasswordAuthException();
      const user = AuthUser(isEmailVerified: false);
      _user = user;
      return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if(!isInitialzed) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if(!isInitialzed) throw NotInitializedException();
    final user = _user;
    if(user ==null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

}