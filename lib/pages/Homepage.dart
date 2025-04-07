import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portfoliobuilder/auth_service/signupwidgets/MyElevatedbutton.dart';
import 'package:portfoliobuilder/auth_service/signupwidgets/mytextfield.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
            height: height * 0.8,
            ///  LANDING PAGE AND SVG IMAGE
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CustomText(
                        text: "Craft Your Stunning Portfolio \nwithin Minutes!",
                        fontWeight: FontWeight.w900,
                        fontSize: 40.sp,
                      ),

                      SizedBox(height: 20),

                      CustomText(
                        text: "Showcase your skills, experience, achievements and projects effortlessly.\nBuild a professional portfolio that stands out — no coding required!",
                        fontWeight: FontWeight.w300,
                        fontSize: 17.sp,
                      ),

                      SizedBox(height: 30.h),

                      CustomElevatedButton(
                          text: "Get Started for free",
                          onPressed: () {},
                        backgroundColor: Color(0XFF111B47),
                        height: 50.h,
                        width: 250.w,
                      )

                    ],

                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(width * 0.010),
                  child: SvgPicture.asset('assets/images/home_image.svg', width: width * 0.35),
                      ),
                    ],
                  ),
                ),



            Padding(
              padding: EdgeInsets.only(left: 90.w, bottom: 10.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                    text: "Manage Your Profile",
                  color: Color(0XFF111B47),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 20.h, left: 100.w, right: 60.w ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [


                  MenuCard(
                      iconPath: 'assets/icons/profile_page.png',
                      title: '💼 Your Career at a Glance',
                      buttonText: 'Profile Page',
                      onPressed: () {
                        context.go('/profileview');
                      },
                    ),


                  MenuCard(
                    iconPath: 'assets/icons/explore.png',
                    title: '🚀 Fill in the Details, Stand Out!',
                    buttonText: 'Form Page',
                    onPressed: () {
                      context.go('/stepperform');
                    },
                  ),

                  MenuCard(
                    iconPath: 'assets/icons/templates.png',
                    title: '🎨 Pick, Style, Impress!',
                    buttonText: 'Choose a template',
                    onPressed: () {
                      context.go('/templateviewpage');
                    },
                  ),

                  MenuCard(
                    iconPath: 'assets/icons/history.png',
                    title: '📜 Generated Portfolios',
                    buttonText: 'View History',
                    onPressed: () {
                      context.go('/stepperform');
                    },
                  ),

                ],
              ),
            ),

            SizedBox(height: 50)




          ]
        ),
      ),
    );
  }
}



class MenuCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String buttonText;
  final VoidCallback onPressed;

  const MenuCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
      child: Container(
        height: height * 0.30,
        width: width * 0.18,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(4,4),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15.w),

            _buildIconContainer(),

            SizedBox(height: 10.w),

            _buildTitleText(),

            SizedBox(height: 10.w),

            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueGrey.shade200
      ),
      child: Padding(
        padding: EdgeInsets.all(30.w),
        child: Image.asset(
          iconPath,
          width: 60.w,
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13.sp,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0XFF111B47),
        foregroundColor: Colors.white,
        minimumSize: Size(200.w, 40.h),
      ),
      child: Text(buttonText),
    );
  }
}
