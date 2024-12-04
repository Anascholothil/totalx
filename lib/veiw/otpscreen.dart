// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:totalx_testpproject/veiw/homescreen.dart';

// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:pinput/pinput.dart';

// import '../Loginprovider.dart';

// class OtpScreen extends StatefulWidget {
//   const OtpScreen({Key? key}) : super(key: key);

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: screenWidth / 15),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: screenHeight / 17),
//               _buildTitle(),
//               SizedBox(height: screenHeight / 28),
//               _buildOtpField(screenHeight, screenWidth),
//               SizedBox(height: screenHeight / 60),
//               _buildTimerText(),
//               SizedBox(height: screenHeight / 30),
//               _buildResendText(),
//               SizedBox(height: screenHeight / 60),
//               _buildVerifyButton(screenHeight, screenWidth, context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTitle() {
//     return Column(
//       children: [
//         Center(child: Image.asset('assets/logimg.png', scale: 3)),
//         Row(
//           children: [
//             Text(
//               'OTP Verification',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//         Row(
//           children: [
//             Text(
//               'Enter the verification code we just sent to your \n number +91 *******21.',
//               style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Colors.black54),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildOtpField(double screenHeight, double screenWidth) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0),
//       child: Pinput(
//         controller: otpController,
//         length: 6,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         defaultPinTheme: PinTheme(
//           textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//           height: 40,
//           width: 40,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.transparent,
//                 blurRadius: 2.0,
//                 spreadRadius: 1.0,
//               ),
//             ],
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(width: 2, color: Color(0xFF6B526B)),
//           ),
//         ),
//         onCompleted: (pin) => _verifyOtp(pin, context),
//       ),
//     );
//   }

//   Widget _buildTimerText() {
//     return Center(
//       child: Text(
//         "59 sec",
//         style: TextStyle(fontSize: 14, color: Colors.red),
//       ),
//     );
//   }

//   Widget _buildResendText() {
//     return Center(
//       child: RichText(
//         text: TextSpan(
//           style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//           children: [
//             TextSpan(text: "Don't Get OTP? "),
//             TextSpan(
//               text: 'Resend',
//               style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVerifyButton(double screenHeight, double screenWidth, BuildContext context) {
//     return Consumer<LoginProviderNew>(
//       builder: (context, loginProvider, child) {
//         return Center(
//           child: TextButton(
//             onPressed: () async {
//               final enteredOtp = otpController.text.trim();
//               if (enteredOtp.isNotEmpty) {
//                 _verifyOtp(enteredOtp, context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please enter the OTP')),
//                 );
//               }
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.black54
//               ,
//               fixedSize: Size(screenWidth / 1.2, screenHeight / 18),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
//             ),
//             child: loginProvider.loader
//                 ? CircularProgressIndicator(color: Colors.white)
//                 : Text(
//               'Verify',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _verifyOtp(String enteredOtp, BuildContext context) async {
//     if (enteredOtp.isNotEmpty) {
//       try {
//         final loginProvider = Provider.of<LoginProviderNew>(context, listen: false);
//         loginProvider.setLoading(true);
//         await loginProvider.verify(context, enteredOtp);

//         if (FirebaseAuth.instance.currentUser != null) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => homePage()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('OTP verification failed, please try again.')),
//           );
//         }
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error verifying OTP. Please try again.')),
//         );
//       } finally {
//         Provider.of<LoginProviderNew>(context, listen: false).setLoading(false);
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter the OTP')),
//       );
//     }
//   }
// }
