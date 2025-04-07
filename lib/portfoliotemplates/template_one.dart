import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePageAlignment extends StatefulWidget {
  const ProfilePageAlignment({super.key});

  @override
  State<ProfilePageAlignment> createState() => _ProfilePageAlignmentState();
}

class _ProfilePageAlignmentState extends State<ProfilePageAlignment> {
  Map<String, dynamic> userData = {};
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    if (doc.exists) {
      setState(() {
        userData = doc.data() ?? {};
        userData['profileImage'] ??= user.photoURL;
        userData['name'] ??= user.displayName ?? "No Name";
        userData['skills'] ??= [];
        userData['projects'] ??= [];
      });
    }
  }

  Future<void> _saveProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .set(userData, SetOptions(merge: true));
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final driveId = userData['profile_image_link'];
    final imageUrl = driveId != null
        ? 'https://drive.google.com/uc?export=view&id=$driveId'
        : 'https://via.placeholder.com/150';

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //  MAIN CONTAINER
          Container(
            height: height * 0.5,
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(left: width * 0.17),
            child: Row(
              children: [
                /// LEFT SIDE - TEXTS
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, I am ${userData['name'] ?? 'Your Name'}",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData['designation'] ?? 'Your Role',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userData['objective'] ?? 'About description...',
                        style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          final url = userData['resume_link'];
                          if (url != null &&
                              await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)
                          ),
                          minimumSize: Size(80, 40.h),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),),
                          child: const Text(
                          "Download Resume",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.15),

                CircleAvatar(
                  radius: width * 0.08,
                  backgroundImage: NetworkImage(
                    userData['profileImage'] ?? 'https://via.placeholder.com/150',
                  ),
                ),


                SizedBox(width: width * 0.15)
              ],
            ),
          ),

          /// SKILLS CONTAINER
          Container(
              color: Color(0XFFEDF7FA),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      "My Skills",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF4A5057), // Match background contrast
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.15,
                          right: width * 0.15,
                          bottom: height * 0.08),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userData['skills'].length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Responsive layout
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 24,
                          childAspectRatio: 1.2, // Adjust for better balance
                        ),
                        itemBuilder: (context, index) {
                          final skill = userData['skills'][index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    skill['skill'],
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0XFF697E87),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    skill['skill_description'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),

          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Projects",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 24.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userData['projects'].length,
                  itemBuilder: (context, index) {
                    final project = userData['projects'][index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Center(
                        child: Container(
                          width: 800.w,
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F6F9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project['name'],
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Duration : ${project['duration']}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                project['project_description'],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
