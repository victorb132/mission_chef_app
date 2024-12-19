import 'package:firebase_auth/firebase_auth.dart';
import 'package:master_chef_app/interfaces/user_service_interface.dart';

class UserService implements IUserService {
  Map<String, String?> _userData = {};

  @override
  Future<void> saveUserData(User user) async {
    _userData = {
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'phoneNumber': user.phoneNumber,
    };
  }

  @override
  Future<Map<String, String?>> getUserData() async {
    return _userData;
  }
}
