import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:videalpha/model/user_model.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  int _timerValue = 60;
  int get timerValue => _timerValue;
  setTimerValue(int value) {
    _timerValue = value;
    notifyListeners();
  }

  String countryCode = '+91';
  String isoCode = 'IN';
  String? verificationId;
  int? resendToken;
  String sendToPhoneNumber = '';

  UserModel? _getUserModelFrom(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            name: user.displayName ?? '',
            dob: null,
            gender: '',
            phone: user.phoneNumber?.startsWith('+') == true
                ? user.phoneNumber?.substring(countryCode.length) ?? ''
                : user.phoneNumber ?? '',
            countryCode: countryCode,
            createDate: user.metadata.creationTime?.millisecondsSinceEpoch ?? 0,
            isoCode: isoCode,
            address: '',
            designation: '',
          )
        : null;
  }

  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      return _getUserModelFrom(user);
    });
  }

  PhoneAuthCredential getPhoneAuthCredential(
      String smsCode, String verificationId) {
    return PhoneAuthProvider.credential(
      smsCode: smsCode,
      verificationId: verificationId,
    );
  }

  Future updateUserProfile(String displayName) async {
    await _auth.currentUser?.updateDisplayName(displayName);
    return true;
  }

  Future<UserModel?> signInWithCredentials(
      PhoneAuthCredential credentials, String saveCredentialsKey) async {
    UserCredential result = await _auth.signInWithCredential(credentials);
    return _getUserModelFrom(result.user);
  }

  Future verifyPhone({
    required String phoneNumber,
    required Function onVerify,
    required Function(FirebaseAuthException) onFailed,
    required Function(String, int?) onCodeSent,
    required Function(String) onCodeTimeout,
    required int? resendToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        final userCredential = await _auth.signInWithCredential(credential);
        onVerify(_getUserModelFrom(userCredential.user));
      },
      verificationFailed: onFailed,
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        this.resendToken = resendToken;
        this.sendToPhoneNumber = phoneNumber;
        setLoading(false);

        Timer.periodic(Duration(seconds: 1), (timer) {
          setTimerValue(60 - timer.tick);
          if (timer.tick > 59) {
            timer.cancel();
          }
        });

        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: onCodeTimeout,
    );
  }

  Future signOut() async {
    try {
      var l = await _auth.signOut();
      return l;
    } catch (e, s) {
      print(e.toString());
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'auth view model file - signOut method');
      return null;
    }
  }
}
