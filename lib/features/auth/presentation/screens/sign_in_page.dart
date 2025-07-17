import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:synovia_ai_telehealth_app/config/routes.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/firebase_sign_in_page.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/loading_screen.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/screens/sign_up_page.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/cta_button.dart';
import 'package:synovia_ai_telehealth_app/features/auth/presentation/widgets/social_media_signin_button.dart';
import 'package:synovia_ai_telehealth_app/features/auth/services/auth_services.dart';
import 'package:synovia_ai_telehealth_app/features/home/home_page.dart';
import 'package:synovia_ai_telehealth_app/features/welcome/personalized_health_insights.dart';
import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isObsecured;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    isObsecured = true;
  }

  Future<void> _signInWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        // Do not push any new page; let main.dart StreamBuilder handle navigation
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Sign in failed';
      if (e.code == 'user-not-found') msg = 'No user found for that email.';
      if (e.code == 'wrong-password') msg = 'Wrong password provided.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Sign in failed: $e')));
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _signInWithGoogle() async {
    final userCred = await authService.signInWithGoogle();
    if (userCred != null) {
      print('Signed in as: ${userCred.user?.displayName}');
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          pageRoute(PersonalizedHealthInsights()),
          (route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google Sign-In failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // variables
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // logo
                SvgPicture.asset(SvgAssets.logo_mark),

                // title
                Text(
                  'Sign In',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 55 * fontSize,
                  ),
                ),

                // subtitle
                Text(
                  'Welcome back! Lets Continue your journey to better health.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    color: lightTextColor,
                    fontSize: 25 * fontSize,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // email field
                    Text(
                      'Email Address',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25 * fontSize,
                      ),
                    ),

                    SizedBox(height: 5),

                    // email
                    TextFormField(
                      controller: _emailController,
                      style: GoogleFonts.nunito(color: Colors.white),
                      key: ValueKey('email'),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter email';
                        if (!val.contains('@')) return 'Enter valid email';
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 15, right: 5),
                          child: SvgPicture.asset(SvgAssets.email),
                        ),
                        hintText: "Enter email",
                        hintStyle: TextStyle(color: lightTextColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: brandColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: brandColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.05),

                    // password field
                    Text(
                      'Password',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25 * fontSize,
                      ),
                    ),

                    SizedBox(height: 5),

                    // password field
                    TextFormField(
                      controller: _passwordController,
                      style: GoogleFonts.nunito(color: Colors.white),
                      key: ValueKey('password'),
                      obscureText: isObsecured,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter password';
                        if (val.length < 6) return 'Password too short';
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 15, right: 5),
                          child: SvgPicture.asset(SvgAssets.password),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObsecured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: lightTextColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isObsecured = !isObsecured;
                            });
                          },
                          color: Colors.white,
                        ),
                        hintText: "Enter your password...",
                        hintStyle: TextStyle(color: lightTextColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: brandColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: brandColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),

                // sign in button
                CtaButton(
                  text: _isLoading ? 'Signing in...' : 'Sign in',
                  svgAssets: SvgAssets.solid_arrow_right_sm,
                  onTap: _isLoading ? null : _signInWithEmailPassword,
                ),

                // Row -> Facebook, Google, Instagram
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialMediaSigninButton(
                        svgAssets: SvgAssets.facebook,
                        onTap: null,
                      ),

                      // Google sign in button
                      InkWell(
                        onTap: () => _signInWithGoogle(),
                        child: SocialMediaSigninButton(
                          svgAssets: SvgAssets.google,
                          onTap: () => _signInWithGoogle(),
                        ),
                      ),

                      SocialMediaSigninButton(
                        svgAssets: SvgAssets.insta,
                        onTap: null,
                      ),
                    ],
                  ),
                ),

                // Row -> Dont have an account? Sign up
                Column(
                  children: [
                    SizedBox(
                      width: screenWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Dont have an Account? \t\t',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 25 * fontSize,
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(context, pageRoute(SignUpPage()));
                            },
                            child: Text(
                              'Sign Up.',
                              style: GoogleFonts.nunito(
                                color: brandColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 25 * fontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          pageRoute(ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        'Forgot your Password?',
                        style: GoogleFonts.nunito(
                          color: brandColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 25 * fontSize,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
