import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:videalpha/common_view/loading_overlay.dart';
import 'package:videalpha/utilities/constants.dart';
import 'package:videalpha/utilities/utils.dart';

import '../../view_model/auth_view_model.dart';
import '../../view_model/user_view_model.dart';

// ignore: must_be_immutable
class VerifyView extends StatelessWidget {
  VerifyView({Key? key}) : super(key: key);

  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Constants.primaryColor),
          elevation: 0,
        ),
        body: LoadingOverlay(
          isLoading: authViewModel.loading,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 100),
              Text(
                'OTP Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please type a OTP verification code \nsent to (+91) 7738260306',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),
              OtpTextField(
                numberOfFields: 6,
                showFieldAsBox: false,
                fieldWidth: 50,
                onSubmit: (String verificationCode) {
                  otpCode = verificationCode;
                },
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Didn\'t get OTP?'),
                    TextButton(
                      child: Text(
                        'Resend${authViewModel.timerValue > 0 ? ' in ${authViewModel.timerValue}\s' : ' OTP'}',
                        style: TextStyle(
                          color: Constants.primaryColor.withAlpha(
                              authViewModel.timerValue > 0 ? 128 : 255),
                        ),
                      ),
                      onPressed: () {
                        final authViewModel =
                            Provider.of<AuthViewModel>(context, listen: false);

                        if (authViewModel.timerValue > 0) return;
                        FocusScope.of(context).unfocus();

                        authViewModel.setLoading(true);

                        try {
                          authViewModel.verifyPhone(
                            phoneNumber: authViewModel.sendToPhoneNumber,
                            resendToken: authViewModel.resendToken,
                            onCodeSent:
                                (String verificationId, int? resendToken) {
                              print("onCodeSent");
                            },
                            onCodeTimeout: (String s) {
                              print("onCodeTimeout");
                              authViewModel.setLoading(false);
                            },
                            onFailed: (e) {
                              print('FirebaseAuthException ${e.message}');
                              Utils.to
                                  .showToast(context, 'Failed to verify phone');
                              authViewModel.setLoading(false);
                            },
                            onVerify: (user) {
                              print("onVerify");
                              authViewModel.setLoading(false);
                            },
                          );
                        } catch (e, s) {
                          print('verifyPhone $e');
                          FirebaseCrashlytics.instance.recordError(e, s,
                              reason: 'verify view - resend otp onPressed');
                          authViewModel.setLoading(false);
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextButton(
                  child: Text(
                    'Verify Code',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    final authViewModel =
                        Provider.of<AuthViewModel>(context, listen: false);
                    verifyCode(authViewModel.sendToPhoneNumber, context);
                  },
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  verifyCode(String phone, context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    authViewModel.setLoading(true);

    try {
      final credential = authViewModel.getPhoneAuthCredential(
        otpCode,
        authViewModel.verificationId!,
      );
      final userModel =
          await authViewModel.signInWithCredentials(credential, phone);
      if (userModel != null) {
        userModel.countryCode = authViewModel.countryCode;
        userModel.isoCode = authViewModel.isoCode;
        userModel.phone = phone.substring(authViewModel.countryCode.length);
        //it will create user in users collection if it is not exists.
        await userViewModel.updateUserData(userModel, isFromLoginPage: true);
      }
      authViewModel.setLoading(false);
    } on FirebaseAuthException catch (e) {
      Utils.to.showToast(context, e.message);
      authViewModel.setLoading(false);
    } catch (e, s) {
      Utils.to.showToast(context, e.toString());
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'verify view - verify code method');
      authViewModel.setLoading(false);
    }
  }
}
