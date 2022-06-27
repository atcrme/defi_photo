import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './dummy_data.dart';
import './common/providers/all_questions.dart';
import './common/providers/user.dart';
import './common/providers/all_students.dart';
import './common/providers/theme_provider.dart';
import './screens/all_students/students_screen.dart';
import './screens/student_info/student_screen.dart';
import './screens/login/login_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider();
    final user = User(name: 'Pariterre');
    final students = AllStudents();
    final questions = AllQuestions();
    prepareDummyData(students, questions);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => theme),
        ChangeNotifierProvider(create: (context) => user),
        ChangeNotifierProvider(create: (context) => students),
        ChangeNotifierProvider(create: (context) => questions),
      ],
      child: Consumer<ThemeProvider>(builder: (context, theme, child) {
        return MaterialApp(
          theme: theme.themeData,
          initialRoute: LoginScreen.routeName,
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            StudentsScreen.routeName: (context) => const StudentsScreen(),
            StudentScreen.routeName: (context) => const StudentScreen(),
          },
        );
      }),
    );
  }
}
