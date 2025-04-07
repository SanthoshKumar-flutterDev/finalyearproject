import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadImageToSupabaseAndSaveToFirestore(BuildContext context) async {
  final input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  input.onChange.listen((event) async {
    final file = input.files?.first;
    if (file == null) return;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((event) async {
      final Uint8List data = reader.result as Uint8List;
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.png';
      final path = 'user/$fileName';

      try {
        // ✅ Upload to Supabase Storage
        final response = await Supabase.instance.client.storage
            .from('profileimage')
            .uploadBinary(
          path,
          data,
          fileOptions: FileOptions(contentType: file.type),
        );

        if (response.isEmpty) {
          throw Exception("Upload failed: Empty response received.");
        }

        // ✅ Get public URL
        final publicUrl = Supabase.instance.client.storage
            .from('profileimage')
            .getPublicUrl(path);

        print('✅ Uploaded image: $publicUrl');

        // ✅ Update Firestore
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('user').doc(uid).update({
            'profileImage': publicUrl,
          });

          print('✅ Image URL saved to Firestore');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile image updated!')),
          );
        } else {
          throw Exception("User not logged in");
        }
      } catch (e, stackTrace) {
        print('❌ Upload or Firestore error: $e');
        print('📌 Stack trace: $stackTrace');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    });
  });
}
