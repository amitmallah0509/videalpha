import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:videalpha/model/user_model.dart';

class UserViewModel with ChangeNotifier {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(UserModel user, {bool isFromLoginPage = false}) async {
    DocumentReference doc = _userCollection.doc(user.uid);
    DocumentSnapshot ref = await doc.get();
    if (ref.exists && isFromLoginPage == false) {
      return await doc.update(user.toMap());
    } else if (ref.exists && isFromLoginPage) {
      // Dont Need To Create or Update Beacause We Just Login In
      return;
    }
    user.createDate = DateTime.now().millisecondsSinceEpoch;
    return await doc.set(user.toMap());
  }

  Stream<UserModel?> fetchCurrentUser() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value(null);
    DocumentReference doc = _userCollection.doc(uid);
    return doc.snapshots().map((event) {
      Map<String, dynamic> data = event.data() as Map<String, dynamic>;
      return UserModel.fromData(data);
    });
  }
}
