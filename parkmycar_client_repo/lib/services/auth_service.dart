import 'package:flutter/material.dart';
import 'package:parkmycar_client_repo/parkmycar_http_repo.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
}

class AuthService extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  AuthStatus get status => _status;

  Person? currentPerson;

  Future<AuthStatus> login(String email) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      List<Person> all = await PersonHttpRepository.instance.getAll();
      var filtered = all.where((e) => e.email == email);
      if (filtered.isNotEmpty) {
        currentPerson = filtered.first;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
    return _status;
  }

  void logout() {
    currentPerson = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
