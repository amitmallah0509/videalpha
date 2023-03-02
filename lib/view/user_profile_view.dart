import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videalpha/model/user_model.dart';
import 'package:videalpha/utilities/constants.dart';
import 'package:intl/intl.dart';

import '../routes/router.gr.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/user_view_model.dart';

// ignore: must_be_immutable
class UserProfileView extends StatelessWidget {
  UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: Text('User Profile'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              final authViewModel =
                  Provider.of<AuthViewModel>(context, listen: false);
              authViewModel.signOut();
            },
            icon: Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: StreamBuilder<UserModel?>(
          stream: userViewModel.fetchCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return Container();

            UserModel userModel = snapshot.data!;
            DateTime? dobDateTime = userModel.dob == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(userModel.dob!);
            DateFormat dateFormat = DateFormat('dd MMM yyyy');
            String dateString =
                dobDateTime == null ? '' : dateFormat.format(dobDateTime);
            // calculating age into years
            int age = dobDateTime == null
                ? 0
                : (DateTime.now().difference(dobDateTime).inDays / 365).floor();

            return ListView(
              children: [
                tile(title: 'Name', data: userModel.name),
                tile(
                    title: 'Phone Number',
                    data: '${userModel.countryCode} ${userModel.phone}'),
                tile(title: 'Gender', data: userModel.gender),
                tile(title: 'Designation', data: userModel.designation),
                tile(
                    title: 'Date of Birth',
                    data: dobDateTime == null ? '-' : '$dateString || ${age}Y'),
                tile(
                  title: 'Address',
                  data: userModel.address,
                ),
                Container(
                  height: 55,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      AutoRouter.of(context)
                          .push(EditProfileViewRoute(user: userModel));
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget tile({required String title, required String data}) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
      ),
      subtitle: Text(
        data,
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }
}
