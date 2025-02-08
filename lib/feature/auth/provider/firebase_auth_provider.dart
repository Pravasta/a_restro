import 'package:flutter/foundation.dart';

import 'package:a_restro/data/model/request/login_request_model.dart';
import 'package:a_restro/data/model/response/user_response_model.dart';
import 'package:a_restro/data/service/local/shared_preferences_key.dart';
import 'package:a_restro/data/service/local/shared_preferences_local_service.dart';
import 'package:a_restro/data/service/remote/firebase_service.dart';
import 'package:a_restro/data/static/firebase_auth_status_static.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService;
  final SharedPreferencesLocalService _localService;

  FirebaseAuthProvider({
    required FirebaseService firebaseService,
    required SharedPreferencesLocalService localService,
  })  : _firebaseService = firebaseService,
        _localService = localService;

  bool _isObsecure = true;

  bool get isObsecure => _isObsecure;

  String _message = '';
  UserResponseModel? _user;
  FirebaseAuthStatusStatic _authStatus =
      FirebaseAuthStatusStatic.unauthenticated;

  UserResponseModel? get user => _user;
  String get message => _message;
  FirebaseAuthStatusStatic get authStatus => _authStatus;

  Future<void> createAccount(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatusStatic.creatingAccount;
      notifyListeners();

      await _firebaseService.createUser(email, password);

      _authStatus = FirebaseAuthStatusStatic.accountCreated;
      _message = "Create account is success";
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatusStatic.error;
      notifyListeners();
    }
  }

  Future signInUser(LoginRequestModel data) async {
    try {
      _authStatus = FirebaseAuthStatusStatic.authenticating;
      notifyListeners();

      final result = await _firebaseService.signInUser(data);

      _user = UserResponseModel(
        name: result.user?.displayName,
        email: result.user?.email,
        photoUrl: result.user?.photoURL,
      );

      await _localService.setSharedPreferences(
        AppSharedPreferencesKey.isLogin,
        data.email,
      );

      _authStatus = FirebaseAuthStatusStatic.authenticated;
      _message = "Sign in is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatusStatic.error;
    }
    notifyListeners();
  }

  Future signOutUser() async {
    try {
      _authStatus = FirebaseAuthStatusStatic.signingOut;
      notifyListeners();

      await _firebaseService.signOut();

      await _localService
          .removeSharedPreferences(AppSharedPreferencesKey.isLogin);

      _authStatus = FirebaseAuthStatusStatic.unauthenticated;
      _message = "Sign out is success";
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatusStatic.error;
      notifyListeners();
    }
  }

  Future<void> getCurrentUser() async {
    try {
      _authStatus = FirebaseAuthStatusStatic.authenticating;
      notifyListeners();

      final result = await _firebaseService.getCurrentUser();
      _authStatus = FirebaseAuthStatusStatic.authenticated;
      _user = UserResponseModel(
        name: result.name,
        email: result.email,
        photoUrl: result.photoUrl,
      );

      notifyListeners();
    } catch (e) {
      _authStatus = FirebaseAuthStatusStatic.error;
      _message = e.toString();
      notifyListeners();
    }
  }

  void changeVisibilityPassword() {
    _isObsecure = !_isObsecure;
    notifyListeners();
  }
}
