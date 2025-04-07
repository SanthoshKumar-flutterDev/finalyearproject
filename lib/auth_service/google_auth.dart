import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
class AuthService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Google Sign in
  Future<void>signInWithGoogle() async{
    try{
      // begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn(
          clientId: "521110865376-gl9bc6hab3037njb5b2ra9d4tav72bjr.apps.googleusercontent.com"
      ).signIn();

      //obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      //create a new credential for user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken
      );


      //Signin to the firebase with the credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      //Get the current user
      User? user = userCredential.user;

      if( user!= null){
        // Get Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Save the user's UID email in firestore
        await firestore.collection('user').doc(user.uid).set({
          'email' : user.email,
          'createdAt' : DateTime.now(),
          'uid' : user.uid,
        },
            SetOptions(merge: true)
        );
        print("User signed in and data saved to firestore : ${user.uid}");
      }
    } catch (e){
      print("Error during Google Sign-In : $e");
    }
  }
}
 */


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Check if the user is logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // 🔹 Google Sign-In function
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn(
        clientId: "521110865376-gl9bc6hab3037njb5b2ra9d4tav72bjr.apps.googleusercontent.com"
      ).signIn();
      if (gUser == null) return null; // User canceled login

      // Obtain authentication details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for the user
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Get the current user
      User? user = userCredential.user;
      if (user != null) {
        // Save user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'createdAt': DateTime.now(),
          'uid': user.uid,
        }, SetOptions(merge: true));

        print("✅ User signed in and data saved: ${user.uid}");
      }
      return userCredential;
    } catch (e) {
      print("❌ Error during Google Sign-In: $e");
      return null;
    }
  }

  // 🔹 Logout function
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
