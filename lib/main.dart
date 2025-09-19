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
import 'package:synovia_ai_telehealth_app/features/auth/services/auth_services.dart';
import 'package:synovia_ai_telehealth_app/features/comprehensive_health_assessment/provider/health_assessment_controller.dart';
import 'package:synovia_ai_telehealth_app/features/symptoms_history/provider/symptoms_history_provider.dart';
import 'package:synovia_ai_telehealth_app/features/welcome/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:synovia_ai_telehealth_app/firebase_options.dart';
import 'features/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/privacy/privacy_policy_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  await ChatProvider.initHive();

  final authService = AuthService();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await authService.attemptSilentSignIn();

  // Activate Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        AndroidProvider.debug, // Change to .playIntegrity for production!
    appleProvider: AppleProvider.debug,
  );

  // Remove splash screen after all initializations are done
  FlutterNativeSplash.remove();

  final prefs = await SharedPreferences.getInstance();
  final accepted = prefs.getBool('privacy_policy_accepted') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) => HealthAssessmentController(),
        ),
        ChangeNotifierProvider(create: (_) => SymptomsHistoryProvider()),
      ],
      child: MyApp(showPrivacyPolicy: !accepted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showPrivacyPolicy;
  const MyApp({super.key, required this.showPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style here for consistency
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: darkBackgroundColor),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Synovia Telehealth App',
      theme: ThemeData.dark(),
      home:
          showPrivacyPolicy
              ? PrivacyPolicyScreen()
              : StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      backgroundColor: darkBackgroundColor,
                      body: Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Scaffold(
                      backgroundColor: darkBackgroundColor,
                      body: Center(
                        child: Text(
                          'Authentication Error',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } else {
                    final user = snapshot.data;
                    if (user != null) {
                      return const HomePage();
                    } else {
                      return FutureBuilder(
                        future: Future.delayed(
                          const Duration(seconds: 1),
                        ), // delay to allow auth restore
                        builder: (context, futureSnap) {
                          if (futureSnap.connectionState !=
                              ConnectionState.done) {
                            return Scaffold(
                              backgroundColor: darkBackgroundColor,
                              body: Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            );
                          } else {
                            return const WelcomePage();
                          }
                        },
                      );
                    }
                  }
                },
              ),
    );
  }
}
