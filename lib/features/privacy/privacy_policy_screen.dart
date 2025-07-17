import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/colors.dart';
import 'package:synovia_ai_telehealth_app/main.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _loading = false;

  Future<void> _acceptPolicy() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('privacy_policy_accepted', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MyApp(showPrivacyPolicy: false)),
      );
    }
  }

  Widget _buildIcon() {
    // Try to use custom asset, fallback to default icon
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: brandColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          'assets/icons/custom/privacy.png',
          width: 40,
          height: 40,
          color: brandColor,
          errorBuilder:
              (context, error, stackTrace) =>
                  Icon(Icons.privacy_tip, color: brandColor, size: 40),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(child: _buildIcon()),
              const SizedBox(height: 18),
              Text(
                'Your Privacy Matters',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please review and accept our privacy policy to continue using the app.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  color: Colors.grey[900],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Text(
                        _samplePolicyText,
                        style: GoogleFonts.nunito(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _acceptPolicy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'I Agree',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

const String _samplePolicyText = '''
We value your privacy and are committed to protecting your personal health information. This app collects and processes your data to provide personalized telehealth services, including symptom tracking, AI chat, and health recommendations.

What We Collect:
• Information you provide (symptoms, chat messages, health records)
• Device information and usage data
• Location data (if you enable location features)

How We Use Your Data:
• To provide and improve telehealth services
• To personalize your experience and recommendations
• To send notifications and reminders (if enabled)
• To comply with legal and regulatory requirements

Your Choices:
• You can access, update, or delete your data at any time
• You can withdraw consent and stop using the app at any time
• You can control notification and location permissions in your device settings

Data Security:
• We use industry-standard security to protect your data
• Your data is never sold to third parties

By tapping "I Agree", you consent to our privacy policy and the processing of your data as described above.
''';
