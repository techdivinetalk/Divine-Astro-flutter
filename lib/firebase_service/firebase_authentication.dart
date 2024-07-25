import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> handleSignInEmail(String email, String password) async {
    UserCredential result =
    await auth.signInWithEmailAndPassword(email: email, password: password);
    print(result);
    print("resultresultresultresult");
    final User user = result.user!;

    return user;
  }
  handleSignOut() async {
    auth.signOut();
  }
  logoutUser(){}
}