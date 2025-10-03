import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _verificationId;
  String? _uid;
  String? _phoneNumber;

  String? get uid => _uid;
  String? get phoneNumber => _phoneNumber;

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required BuildContext context,
    required VoidCallback onCodeSent,
    required Function(String error) onError,
  }) async {
    _setLoading(true);
    try {
      if (kIsWeb) {
        final FirebaseApp app = Firebase.app();

        final confirmationResult =
            await FirebaseAuth.instance.signInWithPhoneNumber(
          phoneNumber,
 // inside AuthProvider.sendOtp, when kIsWeb is true
RecaptchaVerifier(
  container: 'recaptcha',
  size: RecaptchaVerifierSize.compact,
  theme: RecaptchaVerifierTheme.light,
  auth: FirebaseAuthWeb(app: app),
)
        );

        _verificationId = confirmationResult.verificationId;
        onCodeSent();
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) async {
            final userCred = await _auth.signInWithCredential(credential);
            _uid = userCred.user?.uid;
            _phoneNumber = userCred.user?.phoneNumber;
            onCodeSent();
          },
          verificationFailed: (e) {
            onError(e.message ?? 'Phone verification failed');
          },
          codeSent: (verificationId, resendToken) {
            _verificationId = verificationId;
            onCodeSent();
          },
          codeAutoRetrievalTimeout: (verificationId) {
            _verificationId = verificationId;
          },
          timeout: const Duration(seconds: 60),
        );
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp({
    required String smsCode,
    required VoidCallback onSuccess,
    required Function(String error) onError,
  }) async {
    _setLoading(true);
    try {
      if (_verificationId == null) {
        onError('Verification ID is null. Please resend OTP.');
        return;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      final userCred = await _auth.signInWithCredential(credential);
      _uid = userCred.user?.uid;
      _phoneNumber = userCred.user?.phoneNumber;

      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    _uid = null;
    _phoneNumber = null;
    notifyListeners();
  }
}
