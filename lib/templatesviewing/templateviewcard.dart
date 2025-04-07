import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../provider/template_provider.dart';

class PortfolioViewCard extends StatelessWidget {
  final TemplateModel template;

  const PortfolioViewCard({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(color: Colors.indigo.shade50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.asset(
                template.imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 200.w
            ),

            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 5.h),
              child: Text(
                template.title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 5.h, bottom: 5.h),
              child: Text(
                template.description,
                style: TextStyle(fontSize: 9.sp, color: Colors.indigo.shade700),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () {
                    print("Previewing ${template.title}");
                  },
                  child: Text("Preview", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                    minimumSize: Size(140.w, 50.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return; // Ensure user is authenticated

                      String portfolioId = const Uuid().v4(); // Generate unique portfolio ID
                      String userId = user.uid; // Get authenticated user ID
                      String templateId = template.id; // Get selected template ID

                      try {
                        // Fetch user profile data from Firestore
                        DocumentSnapshot userDoc = await FirebaseFirestore.instance
                            .collection('user') // FIX: Ensure the correct collection name
                            .doc(userId)
                            .get();

                        if (!userDoc.exists) {
                          print("User data not found");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("User data not found")),
                          );
                          return;
                        }

                        // Fetch user data safely
                        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};

                        // Prepare portfolio data
                        Map<String, dynamic> portfolioData = {
                          'portfolioId': portfolioId,
                          'templateId': templateId,
                          'userId': userId,
                          'name': userData['name'] ?? 'Anonymous',
                          'description': userData['objective'] ?? '',
                          'skills': userData['skills'] ?? [],
                          'projects': userData['projects'] ?? [],
                          'createdAt': FieldValue.serverTimestamp(),
                          'resume_link' : userData['resume_link']
                        };

                        // Save portfolio in Firestore under the user's history
                        await FirebaseFirestore.instance
                            .collection('user') // FIX: Correct Firestore collection name
                            .doc(userId)
                            .collection('portfolios')
                            .doc(portfolioId)
                            .set(portfolioData);

                        // Navigate to the generated portfolio page
                        context.go('/portfolio/$portfolioId', extra: {
                          'userId': userId,  // ✅ Correct key
                          'templateId': templateId,  // ✅ Correct key
                        }); // FIX: Correct navigation

                      } catch (e) {
                        print("Error saving portfolio: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to generate portfolio. Try again!")),
                        );
                      }
                    },

                  child: Text("Generate", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade900,
                    minimumSize: Size(140.w, 50.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            )
          ],
        ),
      ),
    );
  }
}
