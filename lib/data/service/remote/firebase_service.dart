import 'package:firebase_auth/firebase_auth.dart';

import 'package:a_restro/data/model/request/login_request_model.dart';
import 'package:a_restro/data/model/response/user_response_model.dart';

class FirebaseService {
  final FirebaseAuth _auth;

  FirebaseService({
    required FirebaseAuth auth,
  }) : _auth = auth;

  Future<UserCredential> createUser(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "email-already-in-use" =>
          "There already exists an account with the given email address.",
        "invalid-email" => "The email address is not valid.",
        "operation-not-allowed" => "Server error, please try again later.",
        "weak-password" => "The password is not strong enough.",
        _ => "Register failed. Please try again.",
      };
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserCredential> signInUser(LoginRequestModel data) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "invalid-email" => "The email address is not valid.",
        "user-disabled" => "User disabled.",
        "user-not-found" => "No user found with this email.",
        "wrong-password" => "Wrong email/password combination.",
        _ => "Login failed. Please try again.",
      };
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw "Logout failed. Please try again.";
    }
  }

  Future<UserResponseModel> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      final dataUser = UserResponseModel(
        name: user?.email?.split('@').first,
        email: user?.email ?? '',
        photoUrl: user?.photoURL ?? '',
      );

      return dataUser;
    } catch (e) {
      throw e.toString();
    }
  }

  factory FirebaseService.create() {
    return FirebaseService(
      auth: FirebaseAuth.instance,
    );
  }
}
