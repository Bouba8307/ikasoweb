import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikasoweb/Admin/view/components/Utilisateurs.dart';
import 'package:ikasoweb/Admin/view/main.dart';
import 'package:ikasoweb/Admin/view/signup.dart';
import 'package:ikasoweb/view_models/auth_view_model.dart';
import 'package:ikasoweb/view_models/hebergement_view_model.dart';
import 'package:provider/provider.dart';

import 'Admin/view/login_screen.dart';
import 'view_models/user_view_model.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyATyZeUknN5E_bL13c5M1xZLGRwIgj40Vg",
        authDomain: "projet-fin-formation-52321.firebaseapp.com",
        projectId: "projet-fin-formation-52321",
        storageBucket: "projet-fin-formation-52321.appspot.com",
        messagingSenderId: "473954963388",
        appId: "1:473954963388:web:3fcb663255430564fae5b9",
        measurementId: "G-42YKMNPE06",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DashboardViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ApprovalViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(), 
        ),
      ],
      child: MaterialApp(
        title: 'ikasoDashboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/admin_dashboard': (context) => AdminDashboard(),
          '/signup': (context) => SignupScreen(),
          '/listes_utilisateurs': (context) => ListesUtilisateursScreen(), // Route pour ListesUtilisateursScreen
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
