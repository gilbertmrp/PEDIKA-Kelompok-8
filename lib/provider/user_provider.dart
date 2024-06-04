import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../model/auth/login_request_model.dart';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  User? _user;
  String? _userToken;
  final _storage = const FlutterSecureStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get user => _user;
  bool get isLoggedIn => _userToken != null;

  int? get userId => _user?.id;

  static var client = http.Client();

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    try {
      final response = await APIService().login(identifier, password);
      _user = response.data;
      _userToken = response.token;
      await setUserToken(_userToken!);
      await setUserDetails(_user!);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error login: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName, String phoneNumber) async {
    try {
      print("Attempting to register with phone number: $phoneNumber");
      final response = await APIService().register(email, password, fullName, phoneNumber);
      if (response.success != 200) {
        print("Failed to register, server responded with status code: ${response.success} and body: ${response.data}");
      }
      _user = response.data;
      await setUserToken(_userToken!);
      await setUserDetails(_user!);
      notifyListeners();
      return true;
    }catch(e) {
      print('Error login: $e');
      return false;
    }
  }

  Future<void> setUserToken(String token) async {
    await _storage.write(key: 'userToken', value: token);
    _userToken = token;
  }

  Future<void> setUserDetails(User user) async {
    String userJson = jsonEncode(user.toJson());
    await _storage.write(key: 'userData', value: userJson);
    _user = user;
  }

  Future<void> loadUserDetails() async {
    String? userJson = await _storage.read(key: 'userData');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      _user = User.fromJson(userMap);
    }
  }

  Future<void> loadUserToken() async {
    _userToken = await _storage.read(key: 'userToken');
    print(_userToken);
    if (_userToken != null) {
      await loadUserDetails();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
    } catch (error) {
      print("Gagal memutuskan koneksi: $error");
    }

    await _storage.delete(key: 'userToken');
    await _storage.delete(key: 'userData');
    _userToken = null;
    _user = null;

    notifyListeners();
  }
}
