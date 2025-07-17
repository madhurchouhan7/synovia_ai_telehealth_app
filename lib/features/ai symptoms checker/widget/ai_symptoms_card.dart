// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:synovia_ai_telehealth_app/core/colors.dart';
// import 'package:synovia_ai_telehealth_app/utils/svg_assets.dart';

// class AiSymptomsCard extends StatelessWidget {
//   const AiSymptomsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final fontSize = MediaQuery.of(context).size.width / 600;
//     return Card(
//       color: const Color(0xFF414B44),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // 16
//                     Text(
//                       '16',
//                       style: GoogleFonts.nunito(
//                         color: Colors.white,
//                         fontSize: fontSize * 50,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     // Active symptoms
//                     Text(
//                       'Active symptoms',
//                       style: GoogleFonts.nunito(
//                         color: lightTextColor,
//                         fontSize: fontSize * 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),

//                 // stethoscope icon
//                 InkWell(
//                   onTap: () {},
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SvgPicture.asset(SvgAssets.ic_add),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),

//             TextFormField(
//               // controller: _emailController,
//               style: GoogleFonts.nunito(color: Colors.white),
//               key: ValueKey('email'),

//               decoration: InputDecoration(
//                 fillColor: Color(0xFF1B201D),
//                 filled: true,
//                 prefixIcon: Padding(
//                   padding: EdgeInsets.only(left: 15, right: 5),
//                   child: SvgPicture.asset(SvgAssets.ic_search_bold),
//                 ),
//                 hintText: "Search symptoms...",
//                 hintStyle: TextStyle(color: lightTextColor),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.transparent),
//                   borderRadius: BorderRadius.circular(40),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.transparent),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),

//             // most common symptoms
//             Row(
//               children: [
//                 Text(
//                   '\t Most common ',
//                   style: GoogleFonts.nunito(
//                     color: lightTextColor,
//                     fontSize: fontSize * 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
