import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool _editing = false;
  bool _loading = true;
  bool _saving = false;
  String? _name;
  String? _age;
  String? _gender;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not logged in');
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final data = doc.data() ?? {};
      setState(() {
        _name = data['name'] ?? user.displayName ?? '';
        _age = data['age']?.toString() ?? '';
        _gender = data['gender'] ?? '';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not logged in');
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': _name, 'age': _age, 'gender': _gender},
      );
      setState(() {
        _editing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Personal information updated!',
            style: GoogleFonts.nunito(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e', style: GoogleFonts.nunito())),
      );
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: darkBackgroundColor,
        title: Text(
          'Personal Information',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (!_editing && !_loading)
            IconButton(
              icon: Icon(Icons.edit, color: brandColor),
              onPressed: () => setState(() => _editing = true),
            ),
        ],
      ),
      body:
          _loading
              ? Center(child: CircularProgressIndicator(color: brandColor))
              : _error != null
              ? Center(
                child: Text(
                  _error!,
                  style: GoogleFonts.nunito(color: Colors.red),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      'Name',
                      _name,
                      _editing,
                      (v) => setState(() => _name = v),
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      'Age',
                      _age,
                      _editing,
                      (v) => setState(() => _age = v),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      'Gender',
                      _gender,
                      _editing,
                      (v) => setState(() => _gender = v),
                    ),
                    const SizedBox(height: 32),
                    if (_editing)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saving ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandColor,
                              ),
                              child:
                                  _saving
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        'Save',
                                        style: GoogleFonts.nunito(
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  _saving
                                      ? null
                                      : () => setState(() => _editing = false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white24),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.nunito(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
    );
  }

  Widget _buildField(
    String label,
    String? value,
    bool editing,
    ValueChanged<String> onChanged, {
    TextInputType? keyboardType,
  }) {
    return editing
        ? TextFormField(
          initialValue: value ?? '',
          style: GoogleFonts.nunito(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.nunito(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
          ),
          onChanged: onChanged,
          keyboardType: keyboardType,
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.nunito(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              value ?? '-',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
  }
}
