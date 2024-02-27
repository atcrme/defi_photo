import 'package:defi_photo/common/models/answer.dart';
import 'package:defi_photo/common/models/enum.dart';
import 'package:defi_photo/common/providers/all_questions.dart';
import 'package:defi_photo/common/providers/all_answers.dart';
import 'package:ezlogin/ezlogin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'user.dart';

export 'package:ezlogin/ezlogin.dart';

class Database extends EzloginFirebase with ChangeNotifier {
  ///
  /// This is an internal structure to quickly access the current
  /// user information. These may therefore be out of sync with the database
  ///
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<EzloginStatus> login({
    required String username,
    required String password,
    Future<EzloginUser?> Function()? getNewUserInfo,
    Future<String?> Function()? getNewPassword,
  }) async {
    final status = await super.login(
        username: username,
        password: password,
        getNewUserInfo: getNewUserInfo,
        getNewPassword: getNewPassword);
    _currentUser = await user(username);
    notifyListeners();

    if (currentUser?.userType == UserType.teacher) _fetchAllMyStudents();

    return status;
  }

  @override
  Future<EzloginStatus> logout() {
    _currentUser = null;
    notifyListeners();
    return super.logout();
  }

  @override
  Future<EzloginStatus> modifyUser(
      {required EzloginUser user, required EzloginUser newInfo}) async {
    final status = await super.modifyUser(user: user, newInfo: newInfo);
    if (user.email == currentUser?.email) {
      _currentUser = await this.user(user.email);
      notifyListeners();
    }
    return status;
  }

  @override
  Future<User?> user(String username) async {
    final id = emailToPath(username);
    final data = await FirebaseDatabase.instance.ref('$usersPath/$id').get();
    return data.value == null ? null : User.fromSerialized(data.value);
  }

  final List<User> _myStudents = [];
  Iterable<User> get myStudents => [..._myStudents];

  Future<void> _fetchAllMyStudents() async {
    final data = await FirebaseDatabase.instance
        .ref('$usersPath/${_currentUser!.id}')
        .get();

    _myStudents.clear();

    if (data.value != null) {
      for (final id in (data.value! as Map)['supervising'] ?? []) {
        final student = await user(id);
        if (student != null) _myStudents.add(student);
      }
    }
    notifyListeners();
  }

  Future<EzloginStatus> addStudent(
      {required User newStudent,
      required AllQuestions questions,
      required AllAnswers answers}) async {
    final status = await addUser(newUser: newStudent, password: 'defiPhoto');

    if (status == EzloginStatus.success) {
      // pass
    } else if (status == EzloginStatus.couldNotCreateUser) {
      // If the student was already in the database, we can't add them again,
      // but we can add ourself to the [supervisedBy] list.

      final studentUser = await user(newStudent.email);
      if (studentUser != null) return EzloginStatus.unrecognizedError;

      if (studentUser!.supervisedBy.contains(currentUser!.id)) {
        return EzloginStatus.alreadyCreated;
      }
      if (studentUser.firstName != newStudent.firstName ||
          studentUser.lastName != newStudent.lastName) {
        return EzloginStatus.wrongInfoWhileCreating;
      }

      studentUser.supervisedBy.add(currentUser!.id);
      studentUser.companyNames.add(newStudent.companyNames.last);
      final status = await modifyUser(user: studentUser, newInfo: studentUser);
      if (status != EzloginStatus.success) return status;
    } else {
      return EzloginStatus.unrecognizedError;
    }

    final newSupervising = myStudents.map((e) => e.id).toList();
    newSupervising.add(newStudent.id);
    await FirebaseDatabase.instance
        .ref(usersPath)
        .child('${currentUser!.id}/supervising')
        .set(newSupervising);

    answers.addAll(questions.map(
      (e) => Answer(
        isActive: e.defaultTarget == Target.all,
        actionRequired: ActionRequired.fromStudent,
        createdById: currentUser!.id,
        studentId: newStudent.id,
        questionId: e.id,
      ),
    ));

    _fetchAllMyStudents();
    return EzloginStatus.success;
  }

  Future<EzloginStatus> modifyStudent({required User newInfo}) async {
    final studentUser = await user(newInfo.email);
    if (studentUser == null) return EzloginStatus.userNotFound;

    final status = await modifyUser(user: studentUser, newInfo: newInfo);
    _fetchAllMyStudents();
    return status;
  }
}
