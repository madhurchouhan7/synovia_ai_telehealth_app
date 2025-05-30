import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/provider/chat_provider.dart';
import 'package:synovia_ai_telehealth_app/features/ai%20chat%20bot/provider/settings_provider.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/provider/health_assessment_controller.dart';
import 'package:synovia_ai_telehealth_app/features/error/screens/no_internet_error.dart';
import 'package:synovia_ai_telehealth_app/features/welcome/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await ChatProvider.initHive();

  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) => HealthAssessmentController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class SplashApp extends StatefulWidget {
  const SplashApp({super.key});

  @override
  State<SplashApp> createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(Duration(seconds: 4));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: darkBackgroundColor),
    );
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),

    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synovia Telehealth App',
      theme: ThemeData.dark(),
      home: FutureBuilder<bool>(
        future: _checkInternetConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: darkBackgroundColor,
              body: Center(
                child: LoadingAnimationWidget.progressiveDots(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          }
          if (snapshot.data == true) {
            // Internet connected: check FirebaseAuth
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState != ConnectionState.active) {
                  return Scaffold(
                    backgroundColor: darkBackgroundColor,
                    body: Center(
                      child: LoadingAnimationWidget.progressiveDots(
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                }
                return authSnapshot.hasData
                    ? const HomePage()
                    : const WelcomePage();
              },
            );
          }
          return NoInternetError();
        },
      ),
    );
  }
}
