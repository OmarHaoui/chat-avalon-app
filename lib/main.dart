import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'controllers/chat_controller.dart';
import 'firebase_options.dart';
import 'utils/theme/theme.dart';
import 'views/chat_page.dart';
import 'views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(ChatController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return LoginScreen();
    } else {
      return ChatScreen();
    }
  }
}
