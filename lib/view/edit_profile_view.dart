import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videalpha/model/user_model.dart';
import 'package:videalpha/utilities/constants.dart';
import 'package:intl/intl.dart';
import 'package:videalpha/utilities/utils.dart';

import '../routes/router.gr.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/user_view_model.dart';

// ignore: must_be_immutable
class EditProfileView extends StatelessWidget {
  final UserModel user;

  EditProfileView({Key? key, required this.user}) : super(key: key) {
    //assigning user data to field input.
    _needToSetupProfile = user.name.isEmpty;
    _tfName.text = user.name;
    _tfDesignation.text = user.designation;
    _selectedGenderN.value = user.gender == '' ? genders[0] : user.gender;
    if (user.dob != null) {
      // showing dob in dd MMM yyyy format in view.
      _dobDateTime = DateTime.fromMillisecondsSinceEpoch(user.dob!);
      _tfDob.text = _dateFormat.format(_dobDateTime!);
    }
    _tfAddress.text = user.address;
  }

  bool _needToSetupProfile =
      false; // after first time login user need to be add his details. condition checked based on FirebaseAuth user.displayName.isEmpty
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tfName = TextEditingController(text: '');
  final TextEditingController _tfDesignation = TextEditingController(text: '');
  DateTime? _dobDateTime;
  final ValueNotifier<String> _selectedGenderN = ValueNotifier<String>('');
  final TextEditingController _tfDob = TextEditingController(text: '');
  final TextEditingController _tfAddress = TextEditingController(text: '');
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,
          elevation: 0,
          title: Text(
              _needToSetupProfile ? 'Setup Profile Details' : 'Edit Profile'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              inputField(
                label: 'Name',
                controller: _tfName,
                validator: (value) {
                  if (value?.isEmpty == true) return 'please enter name';
                  return null;
                },
              ),
              ValueListenableBuilder(
                valueListenable: _selectedGenderN,
                builder: (context, String gender, _) {
                  return genderDropDown(gender);
                },
              ),
              inputField(label: 'Designation', controller: _tfDesignation),
              inputField(
                label: 'Date of Birth',
                controller: _tfDob,
                readOnly: true,
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: _dobDateTime ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      _dobDateTime = selectedDate;
                      _tfDob.text = _dateFormat.format(selectedDate);
                    }
                  });
                },
              ),
              inputField(
                  label: 'Address',
                  controller: _tfAddress,
                  inputType: TextInputType.multiline),
              Container(
                height: 55,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextButton(
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      final authViewModel =
                          Provider.of<AuthViewModel>(context, listen: false);
                      final userViewModel =
                          Provider.of<UserViewModel>(context, listen: false);

                      UserModel userModel = UserModel(
                        uid: user.uid,
                        name: _tfName.text,
                        phone: user.phone,
                        countryCode: user.countryCode,
                        isoCode: user.isoCode,
                        gender: _selectedGenderN.value,
                        createDate: user.createDate,
                        address: _tfAddress.text,
                        designation: _tfDesignation.text,
                        dob: _dobDateTime?.millisecondsSinceEpoch,
                      );
                      print(userModel.toMap());

                      userViewModel.updateUserData(userModel);

                      Utils.to.showToast(context, "Profile Save Successfully!");

                      if (_needToSetupProfile) {
                        authViewModel.updateUserProfile(_tfName.text);
                        AutoRouter.of(context).replaceAll(
                          [UserProfileViewRoute()],
                        );
                      } else {
                        AutoRouter.of(context).pop();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField({
    required String label,
    TextInputType inputType = TextInputType.text,
    required TextEditingController controller,
    void Function()? onTap,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: inputType == TextInputType.multiline ? null : 1,
        decoration: InputDecoration(
          labelText: label,
        ),
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
      ),
    );
  }

  Widget genderDropDown(String gender) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 0),
      height: 60,
      child: DropdownButton<String>(
        isExpanded: true,
        value: gender,
        underline: Container(
          height: 1.0,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
          ),
        ),
        items: genders.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: const Text("Select Gender"),
        onChanged: (String? value) {
          if (value != null) {
            _selectedGenderN.value = value;
          }
        },
      ),
    );
  }
}
