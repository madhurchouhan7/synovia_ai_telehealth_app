import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class SelectYourGoalWidget extends StatefulWidget {
  String text;
  String iconPath;
  Color iconBackgroundColor;
  Color iconColor;
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;

  SelectYourGoalWidget({
    super.key,
    required this.text,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.isChecked = false,
    this.onChanged,
  });

  @override
  State<SelectYourGoalWidget> createState() => _SelectYourGoalWidgetState();
}

class _SelectYourGoalWidgetState extends State<SelectYourGoalWidget> {
  late bool _isChecked;
  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant SelectYourGoalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      setState(() {
        _isChecked = widget.isChecked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = MediaQuery.of(context).size.width / 600;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChanged?.call(_isChecked);
      },
      child: Card(
        color: secondaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: _isChecked ? brandColor : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // svg icon
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: widget.iconBackgroundColor,
                      ),
                      width: screenWidth / 8,
                      height: screenWidth / 8,

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          widget.iconPath,
                          // ignore: deprecated_member_use
                          color: widget.iconColor,
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth / 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // 1. Doctor's Name
                        Text(
                          widget.text,
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: fontSize * 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Checkbox(
                value: _isChecked,
                activeColor: brandColor,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                  widget.onChanged?.call(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
