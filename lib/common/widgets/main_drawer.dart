import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './database_clearer.dart';
import '../models/enum.dart';
import '../models/student.dart';
import '../providers/login_information.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/q_and_a/q_and_a_screen.dart';
import '../../screens/all_students/students_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, this.student, this.databaseClearerOptions});

  final Student? student;
  final DatabaseClearerOptions? databaseClearerOptions;

  @override
  Widget build(BuildContext context) {
    final loginType =
        Provider.of<LoginInformation>(context, listen: false).loginType;

    return Drawer(
      child: Scaffold(
        appBar:
            AppBar(title: const Text('Menu principal'), leading: Container()),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loginType == LoginType.student)
              MenuItem(
                  title: 'Retour',
                  onTap: () => Navigator.of(context).pushReplacementNamed(
                      QAndAScreen.routeName,
                      arguments: student)),
            if (loginType == LoginType.teacher)
              MenuItem(
                  title: 'Élèves',
                  onTap: () => Navigator.of(context)
                      .pushNamed(StudentsScreen.routeName)),
            if (loginType == LoginType.teacher)
              MenuItem(
                  title: 'Gestion des questions',
                  onTap: () =>
                      Navigator.of(context).pushNamed(QAndAScreen.routeName)),
            if (loginType == LoginType.teacher &&
                databaseClearerOptions != null &&
                databaseClearerOptions!.allowClearing)
              DatabaseClearer(
                options: databaseClearerOptions!,
                child: const MenuItem(
                    title: "Réinitialiser la\nbase de donnée",
                    iconColor: Colors.red),
              ),
            // const DatabaseDebugger(),
            MenuItem(
                title: 'Déconnexion',
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName)),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({super.key, required this.title, this.onTap, this.iconColor});

  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: Icon(
          Icons.cottage,
          color: iconColor ?? Theme.of(context).colorScheme.secondary,
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        onTap: onTap,
      ),
    );
  }
}
