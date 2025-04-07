import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portfoliobuilder/auth_service/signupwidgets/MyElevatedbutton.dart';
import 'package:portfoliobuilder/auth_service/signupwidgets/mytextfield.dart';

import 'google_auth.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          /// Left Section - SVG Image
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.indigo[900]?.withOpacity(0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/girl.svg',
                      width: size * 0.35,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(right: 50.w, top: 10.w),
                    child: CustomText(
                      text: "Make Portfolio Easily",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.w,
                    ),
                  )
                ],
              ),
            ),
          ),

          /// RIGHT SIDE
          SizedBox(

            width: size * 0.50, // Adjust width as needed
            child: Container(
              color: Colors.indigo[900]?.withOpacity(0.010),
              height: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 70, left: 70),
                  child: SizedBox(
                    width: 450, // Fixed width for form
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Welcome Back !", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                        Text("  Register to make attractive portfolio", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                        SizedBox(height: 100),
                        /// ----  EMAIL ADDRESS FIELD  -----
                        //Text("  Email Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                        SizedBox(height: 10),

                        CustomTextField(
                          hintText: "Enter email or Phone number",
                        ),
                        SizedBox(height: 30),

                        /// ----  PASSWORD FIELD  ----
                        CustomTextField(
                            hintText: "Enter a password"
                        ),
                        SizedBox(height: 40),

                        /// ----  sign in with email button ----
                        CustomElevatedButton(
                          height: 50.h,
                          width: double.infinity,
                          backgroundColor: Colors.deepPurple,
                          elevation: 10,
                          shadowColor: Colors.black,
                          text: 'Sign in with Email',
                          onPressed: () { print("on pressed"); },),



                        SizedBox(height: 40),
                        Row(children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              height: 50,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Or continue with"),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              height: 50,
                            ),
                          ),
                        ]),
                        SizedBox(height: 40),

                        /// ---------- GOOGLE SIGN IN ------------
                        ElevatedButton(
                          onPressed: () async {
                            /*
                            try {
                              AuthService authservice = AuthService();
                              await authservice.signInWithGoogle();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('An error occurred: $e')),
                              );
                            }
                             */
                            try {
                              AuthService authService = AuthService();

                              // Call Google sign-in function
                              UserCredential? userCredential =
                              await authService.signInWithGoogle();

                              // Navigate to home if login successful
                              if (userCredential != null) {
                                context.go('/navigationpage'); // Redirect using go_router
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login failed. Please try again.")),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("An error occurred: $e")),
                              );
                            }



                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 5, // Optional: Add shadow
                            shadowColor: Colors.black54,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20), // Adds spacing
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Ensures button wraps content properly
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/logo/google.png',
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(width: 15), // Reduced spacing for better alignment
                                Text(
                                  "Continue with Google",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )


                      ],
                    ),
                  ),
                ),
              ),
            ),
          )


        ],
      ),
    );
  }
}
