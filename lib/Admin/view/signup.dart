import 'package:flutter/material.dart';
import 'package:ikasoweb/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
                viewModel.signUp(
                  context,
                  emailController.text,
                  passwordController.text,
                  firstNameController.text,
                  lastNameController.text,
                  usernameController.text,
                );
              },
              child: Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
