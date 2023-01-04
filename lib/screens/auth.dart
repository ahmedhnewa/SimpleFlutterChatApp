import 'package:chat_app/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const routeName = '/authScreen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
  final _firebaseFirestore = FirebaseFirestore.instance;
  BuildContext? buildContext;

  void setLoading(bool loading) => mounted
      ? setState(() {
          _isLoading = loading;
        })
      : print('No longer of the widget tree'); // use null
  // if you don't want to print anything to log

  Future<void> _tryAuthenticate(Auth authInfo) async {
    final UserCredential userCredential;
    try {
      setLoading(true);
      if (authInfo.isLogin) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: authInfo.userEmail, password: authInfo.userPassword);
        ScaffoldMessenger.of(buildContext!).showSnackBar(
          const SnackBar(
            content: Text('Welcome back!'),
          ),
        );
        return;
      }

      // create new account

      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: authInfo.userEmail, password: authInfo.userPassword);
      final userUid = userCredential.user!.uid;
      var imageUrl = '';
      if (authInfo.selectedImage != null) {
        final extension = path.extension(authInfo.selectedImage!.path);
        print(extension);
        final uploadTask = await FirebaseStorage.instance
            .ref()
            .child('UserProfileImages')
            .child(userUid + extension)
            .putFile(authInfo.selectedImage!);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }
      await _firebaseFirestore.collection('users').doc(userUid).set({
        'username': authInfo.username,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(buildContext!).showSnackBar(
        const SnackBar(
          content: Text('Account has been created'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      _showError(e.message);
    } catch (e) {
      setLoading(false);
      _showError('Unknown error!!: $e');
    }
  }

  void _showError(dynamic message) {
    ScaffoldMessenger.of(buildContext!).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(buildContext!).errorColor,
        content: Text(
          message ?? 'Unknown error',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(child: FlutterLogo(size: 250)),
            AuthForm(_tryAuthenticate, _isLoading),
          ],
        ),
      ),
    );
  }
}
