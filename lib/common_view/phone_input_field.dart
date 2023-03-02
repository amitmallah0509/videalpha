import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

// ignore: must_be_immutable
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String countryCode;
  final String isoCode;
  final bool enabled;
  final Function(Map<String, dynamic> value) onChanged;

  PhoneInputField({
    required this.controller,
    this.countryCode = '+91',
    required this.onChanged,
    this.isoCode = 'IN',
    this.enabled = true,
  });

  bool? isValid;

  @override
  Widget build(BuildContext context) {
    var initialValue;
    if ((countryCode != '') && (isoCode != ''))
      initialValue = PhoneNumber(
        dialCode: countryCode,
        phoneNumber: controller.text,
        isoCode: isoCode,
      );
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          if (number.phoneNumber != controller.text) {
            try {
              onChanged({
                'dial_code': number.dialCode,
                'isoCode': number.isoCode,
                'phoneNumber': number.phoneNumber,
              });
            } catch (e) {
              print(e.toString());
            }
          }
        },
        selectorButtonOnErrorPadding: 0.0,
        spaceBetweenSelectorAndTextField: 5.0,
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
          trailingSpace: false,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: initialValue,
        formatInput: false,
        onInputValidated: (bool value) {
          isValid = value;
        },
        errorMessage: "Invalid Phone Number",
        keyboardType: TextInputType.number,
        inputDecoration: InputDecoration(
          isDense: false,
          border: enabled ? UnderlineInputBorder() : InputBorder.none,
          contentPadding: EdgeInsets.all(12),
          labelText: 'Phone Number',
        ),
        validator: (phone) {
          if (isValid == false && phone != '') return "Not a valid number";
          if (countryCode.isNotEmpty && phone?.length == 0) {
            return 'please enter phone number';
          }
          if (countryCode.isNotEmpty && (phone?.length ?? 0) < 5) {
            return 'please enter valid phone number';
          }
          return null;
        },
        textFieldController: controller,
        isEnabled: enabled,
      ),
    );
  }
}
