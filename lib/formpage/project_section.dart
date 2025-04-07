import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfoliobuilder/formpage/MyCustomtextformfield.dart';

class ProjectsSection extends StatefulWidget {
  final VoidCallback? onNext;

  const ProjectsSection({super.key, this.onNext});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> projects = [];
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> durationControllers = [];
  List<TextEditingController> descriptionControllers = [];
  Map<int, String?> projectErrors = {};

  @override
  void initState() {
    super.initState();
    _addProject();
  }

  void _addProject() {
    setState(() {
      projects.add({"name": "", "duration": "", "description": ""});
      nameControllers.add(TextEditingController());
      durationControllers.add(TextEditingController());
      descriptionControllers.add(TextEditingController());
      projectErrors[projects.length - 1] = null;
    });
  }

  void _removeProject(int index) {
    if (projects.length > 1) {
      setState(() {
        projects.removeAt(index);
        nameControllers[index].dispose();
        durationControllers[index].dispose();
        descriptionControllers[index].dispose();
        nameControllers.removeAt(index);
        durationControllers.removeAt(index);
        descriptionControllers.removeAt(index);

        Map<int, String?> updatedErrors = {};
        for (int i = 0; i < projects.length; i++) {
          updatedErrors[i] = projectErrors[i];
        }
        projectErrors = updatedErrors;
      });
    }
  }

  void _showValidationError(int index, String message) {
    setState(() {
      projectErrors[index] = message;
    });

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          projectErrors[index] = null;
        });
      }
    });
  }

  Future<void> _saveProjects() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not authenticated");
      return;
    }

    String uid = user.uid;
    List<Map<String, String>> projectList = [];
    for (int i = 0; i < projects.length; i++) {
      projectList.add({
        "name": nameControllers[i].text.trim(),
        "duration": durationControllers[i].text.trim(),
        "project_description": descriptionControllers[i].text.trim(),
      });
    }

    try {
      await FirebaseFirestore.instance.collection("user").doc(uid).set({
        "projects": projectList,
      }, SetOptions(merge: true));

      print("Projects saved successfully!");
      widget.onNext?.call();
    } catch (e) {
      print("Error saving projects: $e");
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
          color: Color(0XFF2A3670) ,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.w),
              Center(
                child: Text(
                  "Projects Section",
                  style: TextStyle(
                    fontSize: 24.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Column(
                children: List.generate(projects.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: nameControllers[index],
                        hintText: "Project ${index + 1} Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            _showValidationError(index, "Project name cannot be empty");
                            return "Project name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: durationControllers[index],
                        hintText: "Duration (e.g. 6 months)",
                      ),
                      CustomTextFormField(
                        controller: descriptionControllers[index],
                        hintText: "Description",
                        maxLines: 3,
                      ),
                      SizedBox(height: 10.h),
                      if (projectErrors[index] != null)
                        Padding(
                          padding: EdgeInsets.only(left: 16, top: 4),
                          child: Text(
                            projectErrors[index]!,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _addProject,
                            icon: Icon(Icons.add),
                            label: Text("Add Project"),
                          ),
                          if (projects.length > 1)
                            TextButton.icon(
                              onPressed: () => _removeProject(index),
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
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF111B47),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.white,
                    minimumSize: Size(120.w, 40.h)
                  ),
                  onPressed: _saveProjects,
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
