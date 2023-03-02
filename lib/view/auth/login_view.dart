import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:videalpha/common_view/loading_overlay.dart';
import 'package:videalpha/common_view/phone_input_field.dart';
import 'package:videalpha/utilities/constants.dart';
import 'package:videalpha/utilities/utils.dart';
import '../../view_model/auth_view_model.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController _phoneController =
      TextEditingController(text: '');
  final _phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: LoadingOverlay(
          isLoading: authViewModel.loading,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 20),
              getLogoSection(),
              SizedBox(height: 20),
              Text(
                'Get Started!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 40),
              getPhoneForm(context),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget getLogoSection() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/videAlpha.png',
            height: 200,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget getPhoneForm(context) {
    return Form(
      key: _phoneFormKey,
      child: Column(
        children: [
          PhoneInputField(
            controller: _phoneController,
            onChanged: (Map<String, dynamic> selection) {
              final authViewModel =
                  Provider.of<AuthViewModel>(context, listen: false);

              if (selection['dial_code'] != null) {
                authViewModel.countryCode = selection['dial_code'];
              }
              if (selection['isoCode'] != null) {
                authViewModel.isoCode = selection['isoCode'];
              }
            },
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
                'Send OTP',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();

                if (_phoneFormKey.currentState?.validate() == true) {
                  final authViewModel =
                      Provider.of<AuthViewModel>(context, listen: false);

                  sendOtpToPhone(
                    '${authViewModel.countryCode}${_phoneController.text}',
                    context,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  sendOtpToPhone(String phone, context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    authViewModel.setLoading(true);

    try {
      authViewModel.verifyPhone(
        phoneNumber: phone,
        resendToken: authViewModel.resendToken,
        onCodeSent: (String verificationId, int? resendToken) {
          print("onCodeSent");
          AutoRouter.of(context).pushNamed('/verify');
        },
        onCodeTimeout: (String s) {
          print("onCodeTimeout");
          authViewModel.setLoading(false);
        },
        onFailed: (e) {
          print('FirebaseAuthException ${e.message}');
          Utils.to.showToast(context, 'Failed to verify phone');
          authViewModel.setLoading(false);
        },
        onVerify: (user) {
          print("onVerify");
          authViewModel.setLoading(false);
        },
      );
    } on FirebaseAuthException catch (e) {
      print('verifyPhone $e');
      Utils.to.showToast(context, e.message);
      authViewModel.setLoading(false);
    } catch (e, s) {
      print('verifyPhone $e');
      Utils.to.showToast(context, e.toString());
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'login view - verify phone method');
      authViewModel.setLoading(false);
    }
  }
}
