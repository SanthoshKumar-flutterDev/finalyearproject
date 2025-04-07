import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../supabasestorage/imagepicker.dart';

class Profileview extends StatefulWidget {
  const Profileview({super.key});

  @override
  State<Profileview> createState() => _ProfileviewState();
}

class _ProfileviewState extends State<Profileview> {
  Map<String, dynamic> userData = {};
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    if (doc.exists && mounted) {
      setState(() {
        userData = doc.data() ?? {};

        // Ensure essential fields are initialized
        userData['profileImage'] ??= user.photoURL;
        userData['name'] ??= user.displayName ?? "No Name";
        userData['skills'] ??= [];
        userData['projects'] ??= [];

        userData['age'] ??= "";
        userData['education'] ??= "";
        userData['location'] ??= "";
        userData['objective'] ??= "";
        userData['designation'] ??= ""; // ✅ Fix: Added missing designation field

        _isLoading = false; // ✅ Data is now loaded
      });
    }
  }

  Future<void> _saveProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('user').doc(user.uid).set(userData, SetOptions(merge: true));
    setState(() => _isEditing = false);
  }

  Widget buildEditableField(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 5.h),
        TextFormField(
          initialValue: userData[key] ?? "",
          enabled: _isEditing,
          onChanged: (value) {
            setState(() {
              userData[key] = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal :width * 0.060, vertical: width * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column - Personal Info
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal : 60.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: EdgeInsets.all(25.w),
                  child: Column(
                    children: [




                      // Profile Image
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundImage: userData['profileImage'] != null && userData['profileImage'].toString().isNotEmpty
                                ? NetworkImage(userData['profileImage'])
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () async {
                                await uploadImageToSupabaseAndSaveToFirestore(context);
                                await _fetchUserData(); // Refresh the image after upload
                              },
                              child: CircleAvatar(
                                radius: 16.r,
                                backgroundColor: Colors.deepPurple,
                                child: Icon(
                                  Icons.add,
                                  size: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),







                      SizedBox(height: 15.h),
                      // Name & Email
                      Text(
                        userData['name'] ?? "No Name",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 7.h),

                      Text("Mail id : ${user?.email ?? "No Email"}", style: TextStyle(color: Colors.black54, fontSize: 12.sp, fontWeight: FontWeight.bold )),

                      SizedBox(height: 5.h),

                      Text("User id : ${user?.uid ?? "no id"}", style: TextStyle(color: Colors.black54, fontSize: 10.sp, fontWeight: FontWeight.bold),),
                      SizedBox(height: 15.h),
                      // Personal Info Section
                      Text("Personal Information", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Divider(),
                      buildEditableField("Full Name", "name"),
                      buildEditableField("Age", "age"),
                      buildEditableField("Location", "location"),
                      buildEditableField("Designation", "designation"), // ✅ Now properly initialized
                      buildEditableField("Education", "education"),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: 20.w), // Space between columns

            // Right Column - Professional Info
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 50.h),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Career Objective
                    
                    Text("Career objective", style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.bold),),
                    TextFormField(
                      maxLines: 2, // Allows multiline input
                      initialValue: userData['objective'], // Fetch from Firestore or state
                      enabled: _isEditing, // Editable mode
                      onChanged: (value) {
                        setState(() {
                          userData['objective'] = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Skills Section
                    Column(
                      children: List.generate((userData['skills'] as List).length, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Skill ${index + 1}:",
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.h),

                            // Skill Field
                            TextFormField(
                              initialValue: userData['skills'][index]['skill'],
                              enabled: _isEditing,
                              onChanged: (value) {
                                setState(() {
                                  userData['skills'][index]['skill'] = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Skill Description Field
                            TextFormField(
                              maxLines: 2,
                              initialValue: userData['skills'][index]['skill_description'],
                              enabled: _isEditing,
                              onChanged: (value) {
                                setState(() {
                                  userData['skills'][index]['skill_description'] = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            Divider(),
                            SizedBox(height: 10.h)
                          ],
                        );
                      }),
                    ),

                    SizedBox(height: 20.h),

                    // Projects Section
                    Column(
                      children: List.generate((userData['projects'] as List).length, (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Project ${index + 1}:",
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.h),

                            // Project Name Field
                            TextFormField(
                              initialValue: userData['projects'][index]['name'],
                              enabled: _isEditing,
                              onChanged: (value) {
                                setState(() {
                                  userData['projects'][index]['name'] = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Project Description Field
                            TextFormField(
                              initialValue: userData['projects'][index]['project_description'],
                              enabled: _isEditing,
                              onChanged: (value) {
                                setState(() {
                                  userData['projects'][index]['project_description'] = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // Project Duration Field
                            TextFormField(
                              initialValue: userData['projects'][index]['duration'],
                              enabled: _isEditing,
                              onChanged: (value) {
                                setState(() {
                                  userData['projects'][index]['duration'] = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: "Project Duration",
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                            SizedBox(height: 30.h)
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isEditing) {
            _saveProfileData();
          } else {
            setState(() => _isEditing = true);
          }
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit),
      ),
    );
  }
}
