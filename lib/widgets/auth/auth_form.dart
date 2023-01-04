import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

import '../../helpers/form_validation.dart';
import '../../models/auth.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.tryAuthenticate, this.isLoading, {super.key});
  final void Function(Auth authInfo) tryAuthenticate;
  final bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final authInfo = Auth();

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();
    if (!isValid) return;
    _formKey.currentState?.save();
    widget.tryAuthenticate(authInfo);
  }

  void _onImageSelected(File imageFile) {
    authInfo.selectedImage = imageFile;
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // onChanged: () => _formKey.currentState?.validate(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!authInfo.isLogin) UserImagePicker(_onImageSelected),
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  // enableSuggestions: false,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      FormInputsValidation.validateEmail(value),
                  onSaved: (newValue) =>
                      authInfo.userEmail = newValue?.trim() ?? '',
                ),
                if (!authInfo.isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) =>
                        FormInputsValidation.validateUsername(value),
                    onSaved: (newValue) =>
                        authInfo.username = newValue?.trim() ?? '',
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) => _trySubmit(),
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      FormInputsValidation.validatePassword(value),
                  onSaved: (newValue) =>
                      authInfo.userPassword = newValue?.trim() ?? '',
                ),
                const SizedBox(height: 20),
                widget.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _trySubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).backgroundColor,
                        ),
                        child: Text(
                          authInfo.isLogin ? 'Login' : 'Signup',
                          // style: TextStyle(color: Theme.of(context).textTheme.subtitle1),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () => setState(() {
                      authInfo.isLogin = !authInfo.isLogin;
                      Future.delayed(const Duration(milliseconds: 100))
                          .then((value) {
                        _formKey.currentState?.validate();
                      });
                    }),
                    child: Text(!authInfo.isLogin
                        ? 'Already a user? Login'
                        : 'Create new account'),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
