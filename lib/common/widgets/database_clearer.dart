import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/common/models/answer.dart';
import '/common/models/discussion.dart';
import '/common/models/enum.dart';
import '/common/models/message.dart';
import '/common/providers/all_questions.dart';
import '/common/providers/all_students.dart';
import '/common/widgets/are_you_sure_dialog.dart';
import '/default_questions.dart';
import '/screens/login/login_screen.dart';
import '../models/database.dart';

class DatabaseClearerOptions {
  const DatabaseClearerOptions({
    this.allowClearing = false,
    this.populateWithDummyData = false,
  });

  final bool allowClearing;
  final bool populateWithDummyData;
}

class DatabaseClearer extends StatefulWidget {
  const DatabaseClearer({
    super.key,
    required this.child,
    required this.options,
    this.title,
    this.onTap,
    this.iconColor,
  });

  final Widget child;
  final DatabaseClearerOptions options;
  final String? title;
  final VoidCallback? onTap;
  final MaterialColor? iconColor;

  @override
  State<DatabaseClearer> createState() => _DatabaseClearerState();
}

class _DatabaseClearerState extends State<DatabaseClearer> {
  late Database _login;
  late AllStudents _students;
  late AllQuestions _questions;

  void _clear() async {
    if (await _confirm()) {
      _clearAll();
    }
  }

  Future<bool> _confirm() async {
    final sure = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AreYouSureDialog(
          title: 'Suppression de la base de donnée',
          content:
              'Êtes-vous certain(e) de vouloir supprimer toute la base de donnée?',
        );
      },
    );
    return sure != null && sure;
  }

  void _clearAll() {
    _login.clearUsers();
    _questions.clear(confirm: true);
    _students.clear(confirm: true);

    if (widget.options.populateWithDummyData) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _addDummyData());
    } else {
      _switchToMainLoginPage();
    }
  }

  void _addDummyData() {
    for (final question in DefaultQuestion.questions) {
      _questions.add(question);
    }

    // We must wait that the questions are actually added to the database
    // before addind answers
    WidgetsBinding.instance.addPostFrameCallback((_) => _answerQuestions());
  }

  void _answerQuestions({int currentQuestion = 0}) {
    _students = Provider.of<AllStudents>(context, listen: false);
    _questions = Provider.of<AllQuestions>(context, listen: false);

    // Wait until student is ready to complete
    if (_students.length != 2 || _questions.length != 9) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _answerQuestions());
      return;
    }

    final benjamin = _students[0];
    if (currentQuestion == 0) {
      _students.setAnswer(
          student: benjamin,
          question: _questions.fromSection(0)[1],
          answer: Answer(actionRequired: ActionRequired.fromStudent));
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _answerQuestions(currentQuestion: 1));
      return;
    }
    if (currentQuestion == 1) {
      _students.setAnswer(
          student: benjamin,
          question: _questions.fromSection(1)[0],
          answer: Answer(
              discussion: Discussion.fromList([
                Message(
                    name: benjamin.firstName,
                    text: "Coucou",
                    creatorId: benjamin.id)
              ]),
              actionRequired: ActionRequired.fromTeacher));
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _answerQuestions(currentQuestion: 2));
      return;
    }
    if (currentQuestion == 2) {
      _students.setAnswer(
          student: benjamin,
          question: _questions.fromSection(5)[1],
          answer: Answer(actionRequired: ActionRequired.fromStudent));
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _answerQuestions(currentQuestion: 3));
      return;
    }
    if (currentQuestion == 3) {
      _students.setAnswer(
          student: benjamin,
          question: _questions.fromSection(5)[1],
          answer: Answer(isValidated: true));
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _answerQuestions(currentQuestion: 4));
      return;
    }
    if (currentQuestion == 4) {
      _students.setAnswer(
          student: benjamin,
          question: _questions.fromSection(5)[2],
          answer: Answer(
              discussion: Discussion.fromList([
                Message(
                    name: benjamin.firstName,
                    text: "Coucou",
                    creatorId: benjamin.id)
              ]),
              actionRequired: ActionRequired.fromTeacher));
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _answerQuestions(currentQuestion: 5));
      return;
    }

    final aurelie = _students[1];
    if (currentQuestion == 5) {
      _students.setAnswer(
          student: aurelie,
          question: _questions.fromSection(5)[2],
          answer: Answer(
              actionRequired: ActionRequired.fromTeacher,
              discussion: Discussion.fromList([
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text: 'Non pas coucou',
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text:
                        'https://cdn.photographycourse.net/wp-content/uploads/2014/11/'
                        'Landscape-Photography-steps.jpg',
                    isPhotoUrl: true,
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text: 'Non pas coucou',
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text: 'Non pas coucou',
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text: 'Non pas coucou',
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text:
                        'https://cdn.photographycourse.net/wp-content/uploads/2014/11/'
                        'Landscape-Photography-steps.jpg',
                    isPhotoUrl: true,
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text: 'Non pas coucou',
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text: 'Non pas coucou',
                    creatorId: aurelie.id),
                Message(
                    name: 'Prof',
                    text: 'Coucou',
                    creatorId: _login.currentUser!.id),
                Message(
                    name: 'Aurélie',
                    text: 'Non pas coucou',
                    creatorId: aurelie.id),
              ])));
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _answerQuestions(currentQuestion: 6));
      return;
    }
    if (currentQuestion == 6) {
      _students.setAnswer(
          student: aurelie,
          question: _questions.fromSection(5)[1],
          answer: Answer(isValidated: true));
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _answerQuestions(currentQuestion: 7));
      return;
    }

    _switchToMainLoginPage();
  }

  void _switchToMainLoginPage() {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    _login = Provider.of<Database>(context, listen: false);
    _students = Provider.of<AllStudents>(context, listen: false);
    _questions = Provider.of<AllQuestions>(context, listen: false);

    return GestureDetector(
      onTap: _clear,
      child: widget.child,
    );
  }
}
