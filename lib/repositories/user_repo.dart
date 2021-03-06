import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:opolah/models/user.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future registerUser(User data) async {
    var resEmail = checkEmail(data.email);
    var resPhone = checkPhone(data.phone);
    final prefs = await SharedPreferences.getInstance();

    String id = "";

    await resEmail.then((value) async {
      await resPhone.then((value2) async {
        if (!value2 && !value) {
          await collection.add(data.toJson(data)).then((value) {
            prefs.setString("userID", value.id);
            id = value.id;
          }).catchError((err) {
            print(err);
          });
        }
      });
    });

    return id;
  }

  Future checkEmail(String email) async {
    var res = await collection.where('email', isEqualTo: email).get();
    if (res.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future checkPhone(String phone) async {
    var res = await collection.where('phone', isEqualTo: phone).get();
    if (res.docs.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future loginUser(String email, String password) async {
    String query = 'phone';
    if (email.contains('@')) {
      query = 'email';
    }
    final prefs = await SharedPreferences.getInstance();

    var res = await collection.where(query, isEqualTo: email).get();

    if (res.docs.length == 0) {
      return "Email or phone doesn't exists";
    } else {
      if (res.docs[0]['password'] == password) {
        User user = User.fromSnapshot(res.docs[0]);
        prefs.setString("userID", res.docs[0].id);
        return user;
      } else {
        return "Password not match";
      }
    }
  }

  Future<String> uploadImage(File image) async {
    String urlRes = "";
    String imageCode = randomAlphaNumeric(10) + ".png";
    Reference fireRef = _firebaseStorage.ref().child(imageCode);

    TaskSnapshot task = await fireRef.putFile(image);
    await task.ref.getDownloadURL().then((value) {
      print(value);
      urlRes = value;
    });

    return urlRes;
  }

  Future updateImage(String id, String image) async {
    bool success = false;
    await collection
        .doc(id)
        .update({'image': image})
        .then((value) => success = true)
        .catchError((onError) => success = false);

    return success;
  }

  Future updateUser(User user) async {
    bool success = false;
    await collection
        .doc(user.id)
        .update(user.toJson(user))
        .then((value) => success = true)
        .catchError((onError) => success = false);

    return success;
  }

  Stream<User> loadUser(String id) {
    return collection.doc(id).snapshots().map((value) {
      return User.fromSnapshot(value);
    });
  }
}
