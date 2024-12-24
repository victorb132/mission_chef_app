import 'package:firebase_auth/firebase_auth.dart';

abstract class IUserService {
  Future<void> saveUserData(User user);
  Future<Map<String, String?>> getUserData();
}
