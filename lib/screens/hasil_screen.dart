// import 'package:flutter/material.dart';
// import 'package:quizz_app/screens/home.dart';
// import 'package:quizz_app/ui/shared/color.dart';

// class HasilScreen extends StatefulWidget {
//   final int score; 
//   HasilScreen(this.score, {Key? key}) : super(key: key);

//   @override
//   _HasilScreenState createState() => _HasilScreenState();
// }

// class _HasilScreenState extends State<HasilScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: AppColor.primaryColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: Text(
//               "Selamat",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: screenWidth * 0.1, // Responsif terhadap lebar layar
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: screenHeight * 0.045, // Responsif terhadap tinggi layar
//           ),
//           Text(
//             "Poin Anda",
//             style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.08), // Responsif terhadap lebar layar
//           ),
//           SizedBox(
//             height: screenHeight * 0.02, // Responsif terhadap tinggi layar
//           ),
//           Text(
//             "${widget.score}",
//             style: TextStyle(
//               color: Colors.orange,
//               fontSize: screenHeight * 0.15, // Responsif terhadap tinggi layar
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(
//             height: screenHeight * 0.2, // Responsif terhadap tinggi layar
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Home(),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               shape: StadiumBorder(),
//               backgroundColor: AppColor.secondaryColor,
//               padding: EdgeInsets.all(screenHeight * 0.03), // Responsif terhadap tinggi layar
//             ),
//             child: const Text(
//               "Ulangi kuis",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
