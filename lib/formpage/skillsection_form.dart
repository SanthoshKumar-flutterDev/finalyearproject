import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfoliobuilder/formpage/MyCustomtextformfield.dart';

class SkillSection extends StatefulWidget {
  final VoidCallback? onNext;

  const SkillSection({super.key, this.onNext});

  @override
  State<SkillSection> createState() => _SkillSectionState();
}

class _SkillSectionState extends State<SkillSection> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> skills = []; // Store skill & description
  List<TextEditingController> skillControllers = [];
  List<TextEditingController> descriptionControllers = [];
  Map<int, String?> skillErrors = {};

  @override
  void initState() {
    super.initState();
    _addSkill();
  }

  void _addSkill() {
    setState(() {
      skills.add({"skill": "", "description": ""});
      skillControllers.add(TextEditingController());
      descriptionControllers.add(TextEditingController());
      skillErrors[skills.length - 1] = null;
    });
  }

  void _removeSkill(int index) {
    if (skills.length > 1) {
      setState(() {
        skills.removeAt(index);
        skillControllers[index].dispose();
        descriptionControllers[index].dispose();
        skillControllers.removeAt(index);
        descriptionControllers.removeAt(index);

        // Rebuild skillErrors map to maintain correct indices
        Map<int, String?> updatedErrors = {};
        for (int i = 0; i < skills.length; i++) {
          updatedErrors[i] = skillErrors[i];
        }
        skillErrors = updatedErrors;
      });
    }
  }

  void _showValidationError(int index, String message) {
    setState(() {
      skillErrors[index] = message;
    });

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          skillErrors[index] = null;
        });
      }
    });
  }

  /// **🔥 Save Skills to Firestore**
  Future<void> _saveSkills() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not authenticated");
      return;
    }

    String uid = user.uid;

    // Prepare skills data
    List<Map<String, String>> skillList = [];
    for (int i = 0; i < skills.length; i++) {
      skillList.add({
        "skill": skillControllers[i].text.trim(),
        "skill_description": descriptionControllers[i].text.trim(),
      });
    }

    try {
      await FirebaseFirestore.instance.collection("user").doc(uid).set({
        "skills": skillList,
      }, SetOptions(merge: true));

      print("Skills saved successfully!");
      widget.onNext?.call(); // Move to next step after saving
    } catch (e) {
      print("Error saving skills: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Color(0XFF2A3670), // Match the PersonalSection UI
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.w),
              Center(
                child: Text(
                  "Skills Section",
                  style: TextStyle(
                    fontSize: 24.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              /// **List of Skills**
              Column(
                children: List.generate(skills.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// **Skill Input Field**
                      CustomTextFormField(
                        controller: skillControllers[index],
                        hintText: "Skill ${index + 1}",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _showValidationError(index, "Skill cannot be empty");
                            return "Skill cannot be empty";
                          }
                          return null;
                        },
                      ),

                      /// **Description Input Field**
                      CustomTextFormField(
                        controller: descriptionControllers[index],
                        hintText: "Description ${index + 1}",
                        maxLines: 3,
                      ),

                      SizedBox(height: 10.h),

                      /// **Validation Error Display**
                      if (skillErrors[index] != null)
                        Padding(
                          padding: EdgeInsets.only(left: 16, top: 4),
                          child: Text(
                            skillErrors[index]!,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),

                      SizedBox(height: 10.h),

                      /// **Add Skill & Remove Skill Buttons**
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// **Add Skill Button**
                          ElevatedButton.icon(
                            onPressed: _addSkill,
                            icon: Icon(Icons.add),
                            label: Text("Add Skill"),
                          ),

                          /// **Remove Button (Only if More Than One Skill)**
                          if (skills.length > 1)
                            TextButton.icon(
                              onPressed: () => _removeSkill(index),
                              icon: Icon(Icons.delete, color: Colors.red),
                              label: Text("Remove", style: TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),

                      SizedBox(height: 10.h),
                    ],
                  );
                }),
              ),

              SizedBox(height: 20.h),

              /// **Save & Next Button**

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF111B47),
                      foregroundColor: Colors.white,
                      minimumSize: Size(120.w, 40.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    onPressed: _saveSkills,
                    child: Text("Confirm & Save"),
                  ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
