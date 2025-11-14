
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/add_item.dart';
import 'package:frontend/change_password.dart';
import 'package:frontend/custom_provider.dart';
import 'package:frontend/landing.dart';
import 'package:frontend/settings.dart';
import 'package:frontend/signin.dart';
import 'package:frontend/signup.dart';
import 'package:frontend/viewlist.dart';
import 'lists.dart';

CustomProvider customProvider = CustomProvider();

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CustomProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasklist App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const Landing(),
        "/signin": (context) => const SignIn(),
        "/signup": (context) => const SignUp(),
        "/lists": (context) => const Lists(),
        ViewList.routeName: (context) => const ViewList(),
        AddItem.routeName: (context) => const AddItem(),
        "/settings": (context) => const Settings(),
        "/changepass": (context) => const ChangePassword(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
