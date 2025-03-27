import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synovia_ai_telehealth_app/core/colors.dart';

class ForgotMethods extends StatefulWidget {
  const ForgotMethods({
    super.key,
    required this.primaryText,
    required this.secondaryText,
    required this.svgAssets,
  });
  final String primaryText;
  final String secondaryText;
  final String svgAssets;

  @override
  State<ForgotMethods> createState() => _ForgotMethodsState();
}

class _ForgotMethodsState extends State<ForgotMethods> {
  bool isSelected = false;

  void toggleSelection() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth / 600;
    return InkWell(
      splashColor: darkBackgroundColor,
      highlightColor: darkBackgroundColor,
      onTap: () {
        toggleSelection();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? brandColor : Colors.transparent,
            width: 2,
          ),
          color: secondaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 5, top: 20, bottom: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Icon Container
              Container(
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xff365314) : darkBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    widget.svgAssets,
                    width: 30,
                    colorFilter: ColorFilter.mode(
                      isSelected ? brandColor : Color(0xffA2A9A4),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              // Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // primary text
                  Text(
                    widget.primaryText,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 32 * fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // secondary text
                  Text(
                    widget.secondaryText,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      color: lightTextColor,
                      fontSize: 22 * fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
