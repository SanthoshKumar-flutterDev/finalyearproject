import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfoliobuilder/auth_service/google_auth.dart';
import 'package:portfoliobuilder/auth_service/signupwidgets/MyElevatedbutton.dart';
import 'package:portfoliobuilder/formpage/MyCustomtextformfield.dart';
import 'package:portfoliobuilder/pagerouting/Navigationbar.dart';



class PersonalSection extends StatefulWidget {
  final VoidCallback? onNext;

  PersonalSection({super.key, this.onNext});

  @override
  _PersonalSectionState createState() => _PersonalSectionState();
}

class _PersonalSectionState extends State<PersonalSection> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();

  final TextEditingController photolinkcontroller = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController phonecontroller = TextEditingController();

  final TextEditingController educationController = TextEditingController();

  final TextEditingController jobController = TextEditingController();

  final TextEditingController objectiveController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController mailcontroller = TextEditingController();

  final TextEditingController resume_link = TextEditingController();

  // Function to validate and proceed
  void validateAndProceed() {
    if (_formKey.currentState!.validate()) {
      widget.onNext?.call(); // Safely call onNext if it's not null
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Color(0XFF2A3670) // Darker shade for contrast
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 24.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color for better contrast
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Fields with correct controllers
                  CustomTextFormField(
                    controller: nameController,
                    hintText: "Full Name",
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: photolinkcontroller,
                    hintText: "profile photo link",
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: ageController,
                    hintText: "Age",
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: jobController,
                    hintText: "Designation",
                  ),

                  CustomTextFormField(
                    controller: resume_link,
                    hintText: "Resume Link",
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: phonecontroller,
                    hintText: "Phone",
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: mailcontroller,
                    hintText: "Email Address",
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: educationController,
                    hintText: "Highest Education",
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: objectiveController,
                    hintText: "Career Objective",
                    maxLines: 3,
                  ),

                  SizedBox(height: 5.h),

                  CustomTextFormField(
                    controller: locationController,
                    hintText: "Location",
                  ),

                  SizedBox(height: 20.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: CustomElevatedButton(
                      backgroundColor: Color(0XFF111B47),
                      text: "Confirm & Save",
                      onPressed: () async {
                        try {
                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            String uid = user.uid;
                            String email = user.email ?? "No Email"; // Get user email
                            String displayName = user.displayName ?? "No Name"; // Get display name

                            print("Saving data for user: $uid"); // Debugging print

                            await FirebaseFirestore.instance.collection("user").doc(uid).set({
                              "uid": uid,
                              "email": email,
                              "displayName": displayName,
                              if (nameController.text.isNotEmpty) "name": nameController.text,
                              if (ageController.text.isNotEmpty) "age": ageController.text,
                              if (jobController.text.isNotEmpty) "designation": jobController.text,
                              if (objectiveController.text.isNotEmpty) "objective": objectiveController.text,
                              if (locationController.text.isNotEmpty) "location": locationController.text,
                              if (educationController.text.isNotEmpty) "education": educationController.text,
                              if (photolinkcontroller.text.isNotEmpty) "profile_image_link": photolinkcontroller.text,
                              if (resume_link.text.isNotEmpty) "resume_link": resume_link.text,
                            }, SetOptions(merge: true));


                            print("User data saved successfully!");
                          } else {
                            print("No authenticated user found!");
                          }
                        } catch (e) {
                          print("Error saving user data: $e");
                        }
                      },
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      );
  }
}
